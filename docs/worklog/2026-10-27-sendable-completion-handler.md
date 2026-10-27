# 2026-10-27 — Sendable completion handlers in MTAFeedDownloader

## Fix: non-Sendable `completionHandler` captured in `@Sendable` closure

- Error: `MTAFeedDownloader.swift:46: Capture of 'completionHandler' with non-Sendable type '(MTAFeedWrapper?, MTAFeedDownloadError?) -> Void' in a '@Sendable' closure`.
- Cause: the public `download(with:completionHandler:)` passed its handler into the private `download(with:completionHandler:)`, whose closure parameter is `@Sendable` (it runs on a `URLSession` callback queue).
- Change: marked `completionHandler` as `@escaping @Sendable` in both public callback variants, `download(from:completionHandler:)` and `download(with:completionHandler:)`. The `from:` variant forwards to the `with:` variant, so it had to change too.
- `swift build` succeeds. Two `SendableMetatypes` warnings remain ("capture of non-Sendable type 'K.Type' in an isolated closure", lines 45 and 64). They can be fixed by requiring `K: MTAFeedURL & SendableMetatype` or making `MTAFeedURL` refine `SendableMetatype`. That change was not made here.
