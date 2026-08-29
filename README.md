# iamtgray.com

Personal blog, built with [Hugo](https://gohugo.io/) using the
[hello-friend-ng](https://github.com/rhazdon/hugo-theme-hello-friend-ng) theme
(vendored under `themes/`). Hosted on GitHub Pages at https://iamtgray.com.

## Publishing

Deployment is automated. **Just push markdown to `master`** — a GitHub Actions
workflow (`.github/workflows/hugo.yml`) builds the site with Hugo and publishes
it to GitHub Pages. No compiled output is tracked in the repo.

To add a post:

1. Create `content/posts/my-post.md` (front matter + body; set `draft = false`).
2. Commit and push to `master`.
3. The Actions run builds and deploys within a couple of minutes.

## Local preview (optional)

Use Docker so local matches CI exactly — same pinned Hugo **extended** version,
no host install. From the repo root:

```sh
docker compose up          # live-reload preview at http://localhost:1313 (drafts included)
```

To reproduce the production build (outputs to `public/`, gitignored):

```sh
docker compose run --rm hugo hugo --minify
```

The Hugo version is pinned in `Dockerfile` (`HUGO_VERSION`) and mirrored in
`.github/workflows/hugo.yml`; bump both together when upgrading. The custom
domain is shipped via `static/CNAME`.

Prefer a native install instead? `brew install hugo` (the Homebrew formula is
the extended edition) and run `hugo server -D`.
