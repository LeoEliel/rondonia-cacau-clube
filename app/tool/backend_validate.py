#!/usr/bin/env python3
"""Backend validation for Rondônia Cacau Clube.

Exercises every Firestore security-rule path (positive + negative controls)
against the LIVE backend using a throwaway auth user, then self-cleans.
Reads the Web API key + project id from the local (git-ignored)
app/lib/firebase_options.dart so no secret is hard-coded here.
"""
import json
import os
import re
import sys
import time
import urllib.request
import urllib.error

# firebase_options.dart is git-ignored (holds the Web API key) but exists
# locally so the app builds; resolve it relative to this script (app/tool/).
ROOT = os.path.join(os.path.dirname(__file__), "..", "lib", "firebase_options.dart")

# ---- locate web apiKey + projectId from firebase_options.dart -------------
src = open(ROOT).read()
web_block = src.split("static const FirebaseOptions web", 1)[1]
API_KEY = re.search(r"apiKey:\s*'([^']+)'", web_block).group(1)
PID = re.search(r"projectId:\s*'([^']+)'", web_block).group(1)

FS = f"https://firestore.googleapis.com/v1/projects/{PID}/databases/(default)/documents"
ID = "https://identitytoolkit.googleapis.com/v1"

passes, fails = [], []


def req(method, url, body=None, token=None, expect=None):
    """HTTP request. Returns (status, json). expect=set of OK statuses."""
    data = json.dumps(body).encode() if body is not None else None
    r = urllib.request.Request(url, data=data, method=method)
    r.add_header("Content-Type", "application/json")
    if token:
        r.add_header("Authorization", "Bearer " + token)
    try:
        resp = urllib.request.urlopen(r)
        return resp.status, json.loads(resp.read() or "{}")
    except urllib.error.HTTPError as e:
        return e.code, json.loads(e.read() or "{}")


def check(name, cond, detail=""):
    (passes if cond else fails).append(name)
    mark = "✅" if cond else "❌"
    print(f"  {mark} {name}" + (f"  [{detail}]" if detail and not cond else ""))


def first_doc_id(collection):
    st, j = req("GET", f"{FS}/{collection}?pageSize=1")
    docs = j.get("documents", [])
    if not docs:
        return None, st, 0
    name = docs[0]["name"]
    # full count (best-effort, single page)
    sta, ja = req("GET", f"{FS}/{collection}?pageSize=300")
    return name.split("/")[-1], st, len(ja.get("documents", []))


print(f"\n== Backend validation :: project {PID} ==\n")

# 1) PUBLIC CATALOG READ (no auth) ----------------------------------------
print("1. Public catalog read (unauthenticated)")
prod_id, pst, pc = first_doc_id("products")
prc_id, rst, rc = first_doc_id("producers")
lot_id, lst, lc = first_doc_id("origin_lots")
check(f"products readable & seeded ({pc} docs)", pst == 200 and pc > 0)
check(f"producers readable & seeded ({rc} docs)", rst == 200 and rc > 0)
check(f"origin_lots readable & seeded ({lc} docs)", lst == 200 and lc > 0)

# 2) AUTH: throwaway signup ------------------------------------------------
print("\n2. Auth (Email/Password)")
email = f"validate_{int(time.time())}@example.com"
st, j = req("POST", f"{ID}/accounts:signUp?key={API_KEY}",
            {"email": email, "password": "Test123!pw", "returnSecureToken": True})
token = j.get("idToken")
uid = j.get("localId")
check("email/password signup works", st == 200 and bool(token), f"{st} {j.get('error',{}).get('message','')}")
if not token:
    print("\nCannot continue without a token. Aborting.")
    sys.exit(1)

# 3) USERS: owner write, public read, cross-user denied -------------------
print("\n3. Users (profile provisioning)")
st, _ = req("PATCH", f"{FS}/users/{uid}",
            {"fields": {"name": {"stringValue": "Validator"},
                        "isPaid": {"booleanValue": False}}}, token=token)
check("owner can create own profile (ensureProfile)", st == 200, str(st))
st, _ = req("GET", f"{FS}/users/{uid}")
check("profiles are publicly readable", st == 200, str(st))
st, _ = req("PATCH", f"{FS}/users/someone_else_uid",
            {"fields": {"name": {"stringValue": "hax"}}}, token=token)
check("writing another user's profile DENIED (negative)", st == 403, str(st))

# 4) REVIEWS: create by author, rating-bounded ----------------------------
print("\n4. Reviews")
review_doc = {"fields": {
    "userId": {"stringValue": uid},
    "productId": {"stringValue": prod_id},
    "rating": {"integerValue": "5"},
    "comment": {"stringValue": "validation"},
}}
st, j = req("POST", f"{FS}/reviews", review_doc, token=token)
review_id = j.get("name", "").split("/")[-1] if st == 200 else None
check("author can create a review", st == 200, str(st))
# negative: rating out of range
bad = json.loads(json.dumps(review_doc))
bad["fields"]["rating"] = {"integerValue": "9"}
st, _ = req("POST", f"{FS}/reviews", bad, token=token)
check("rating>5 DENIED (negative)", st == 403, str(st))
# negative: spoofed userId
spoof = json.loads(json.dumps(review_doc))
spoof["fields"]["userId"] = {"stringValue": "not_me"}
st, _ = req("POST", f"{FS}/reviews", spoof, token=token)
check("spoofed userId DENIED (negative)", st == 403, str(st))

# 5) PRODUCTS: reviewCount bump only --------------------------------------
print("\n5. Product reviewCount counter")
st, pj = req("GET", f"{FS}/products/{prod_id}")
orig_rc = int(pj["fields"].get("reviewCount", {}).get("integerValue", "0"))
st, _ = req("PATCH",
            f"{FS}/products/{prod_id}?updateMask.fieldPaths=reviewCount",
            {"fields": {"reviewCount": {"integerValue": str(orig_rc + 1)}}}, token=token)
check("signed-in user can bump reviewCount", st == 200, str(st))
# negative: edit another field
st, _ = req("PATCH",
            f"{FS}/products/{prod_id}?updateMask.fieldPaths=name",
            {"fields": {"name": {"stringValue": "HACKED"}}}, token=token)
check("editing a non-reviewCount product field DENIED (negative)", st == 403, str(st))

# 6) PRODUCERS: followerCount bump only -----------------------------------
print("\n6. Producer followerCount counter")
st, rj = req("GET", f"{FS}/producers/{prc_id}")
orig_fc = int(rj["fields"].get("followerCount", {}).get("integerValue", "0"))
st, _ = req("PATCH",
            f"{FS}/producers/{prc_id}?updateMask.fieldPaths=followerCount",
            {"fields": {"followerCount": {"integerValue": str(orig_fc + 1)}}}, token=token)
check("signed-in user can bump followerCount", st == 200, str(st))
st, _ = req("PATCH",
            f"{FS}/producers/{prc_id}?updateMask.fieldPaths=name",
            {"fields": {"name": {"stringValue": "HACKED"}}}, token=token)
check("editing a non-followerCount producer field DENIED (negative)", st == 403, str(st))

# 7) SUBSCRIPTIONS: private to owner --------------------------------------
print("\n7. Subscriptions (private)")
st, _ = req("PATCH", f"{FS}/subscriptions/{uid}",
            {"fields": {"tier": {"stringValue": "club"}}}, token=token)
check("owner can write own subscription", st == 200, str(st))
st, _ = req("GET", f"{FS}/subscriptions/other_uid_xyz", token=token)
check("reading another user's subscription DENIED (negative)", st in (403,), str(st))

# 8) ORIGIN LOTS: read-only -----------------------------------------------
print("\n8. Origin lots (read-only)")
st, _ = req("PATCH", f"{FS}/origin_lots/{lot_id}?updateMask.fieldPaths=note",
            {"fields": {"note": {"stringValue": "x"}}}, token=token)
check("writing an origin_lot DENIED (negative)", st == 403, str(st))

# ---- CLEANUP -------------------------------------------------------------
print("\n== Cleanup ==")
if review_id:
    req("DELETE", f"{FS}/reviews/{review_id}", token=token)
req("PATCH", f"{FS}/products/{prod_id}?updateMask.fieldPaths=reviewCount",
    {"fields": {"reviewCount": {"integerValue": str(orig_rc)}}}, token=token)
req("PATCH", f"{FS}/producers/{prc_id}?updateMask.fieldPaths=followerCount",
    {"fields": {"followerCount": {"integerValue": str(orig_fc)}}}, token=token)
req("DELETE", f"{FS}/subscriptions/{uid}", token=token)
req("DELETE", f"{FS}/users/{uid}", token=token)
st, _ = req("POST", f"{ID}/accounts:delete?key={API_KEY}", {"idToken": token})
print(f"  cleaned review/counters/subscription/profile + deleted auth user ({st})")

# ---- SUMMARY -------------------------------------------------------------
print(f"\n== RESULT: {len(passes)}/{len(passes)+len(fails)} checks passed ==")
if fails:
    print("FAILED:", ", ".join(fails))
    sys.exit(1)
print("All backend rule paths behave as designed. ✅")
