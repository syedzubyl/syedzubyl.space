# Vercel Deployment & Compatibility Status

## Current Status
Vercel deployment is **NOT** recommended for this project due to compatibility issues with Zola 0.22.1.

Specifically, Vercel's default Amazon Linux build environment has an outdated GLIBC version. This causes the Zola binary to fail with `GLIBC_2.35 not found`. Furthermore, older versions of Zola available on Vercel do not support the `page.colocated_path` variable and `get_image_metadata` logic used by our `img.html` shortcode.

Because of this, all custom Vercel build scripts (`vercel-build.sh`) and configuration files (`vercel.json`) have been **removed** from the repository to keep the codebase clean.

## Recommended Alternative: Cloudflare Pages

If you want the fastest path to deployment, **Cloudflare Pages** is highly recommended over Vercel for this project.

### Reasons:
- ✅ **You already use Cloudflare.**
- ✅ **Static sites are first-class on Cloudflare Pages.**
- ✅ **Custom domains and SSL are automatic.**
- ✅ **No GLIBC issues.** Cloudflare uses modern Ubuntu environments that support Zola 0.22.1 natively.
- ✅ **No need to fight Vercel's Zola runtime.**

*Note: Netlify is also a fully supported alternative, as configured in our `netlify.toml`.*

## What if you MUST use Vercel?

If you absolutely must deploy to Vercel in the future, the fix is **not** in `config.toml` or `netlify.toml`. You would need to adopt one of these three approaches:

1. **Build the site with Docker:** Provide a Docker environment using Zola 0.22.1, assuming you set up Vercel to support it.
2. **Compile Zola from source:** Run a script during Vercel's build step to compile Zola using Rust (`cargo install zola`), which adds 10+ minutes to the build time.
3. **Modify the theme:** Completely rewrite the `img.html` shortcode to remove `page.colocated_path` and downgrade the codebase to be compatible with Vercel's older Zola version. (This is the most work and removes modern Zola features).

**Conclusion:** We recommend deploying via Cloudflare Pages or fixing any remaining Netlify SSL issues instead of spending time working around Vercel's limitations.
