#!/usr/bin/env python3
"""Minimal static server for the built Flutter web app (build/web).

Sets the MIME types Flutter web needs (notably application/wasm for CanvasKit),
which the stdlib SimpleHTTPRequestHandler doesn't get right by default.

Usage: python3 tool/serve_web.py [port]
"""
import sys
from functools import partial
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer


class Handler(SimpleHTTPRequestHandler):
    extensions_map = {
        **SimpleHTTPRequestHandler.extensions_map,
        ".js": "text/javascript",
        ".mjs": "text/javascript",
        ".wasm": "application/wasm",
        ".json": "application/json",
        ".symbols": "text/plain",
    }

    def end_headers(self):
        # Allow the CanvasKit CDN / picsum images and avoid aggressive caching.
        self.send_header("Cache-Control", "no-store")
        super().end_headers()


def main():
    port = int(sys.argv[1]) if len(sys.argv) > 1 else 8080
    handler = partial(Handler, directory="build/web")
    server = ThreadingHTTPServer(("0.0.0.0", port), handler)
    print(f"Serving build/web on http://0.0.0.0:{port}")
    server.serve_forever()


if __name__ == "__main__":
    main()
