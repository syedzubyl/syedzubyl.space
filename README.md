# Syed Zubyl N - Portfolio Website

This repository contains the source code for the personal portfolio and blog of Syed Zubyl N, built using [Zola](https://www.getzola.org/).

The site is designed for high performance, utilizing static generation, automatic image processing (lazy loading, responsive WebP), and an optimal SEO setup.

---

## 🛠 Requirements

To run this project locally, you only need:
- **[Zola](https://www.getzola.org/documentation/getting-started/installation/)** (Version `0.22.1` or newer)

---

## 🚀 Installation & Development

1. **Clone the repository:**
   ```bash
   git clone https://github.com/syedzubyl/syedzubyl.space.git
   cd syedzubyl.space
   ```

2. **Run the local development server:**
   ```bash
   zola serve
   ```
   *The server will start at `http://127.0.0.1:1111` and will live-reload automatically when you make changes to files.*

3. **Build the site for production:**
   ```bash
   zola build
   ```
   *This compiles the Sass, resizes and processes images, and generates the static HTML in the `public/` directory.*

---

## 📂 Folder Structure

- `content/`: Markdown files containing the actual text, blog posts, and page data.
- `sass/`: SCSS files for styling. Zola compiles these automatically.
- `static/`: Static assets like icons, fonts, the CV, and images (which are automatically processed by Zola).
- `templates/`: HTML templates using Tera templating language to define the layout and structure of the site.
- `public/`: The output folder created after running `zola build`. (Ignored in Git).

---

## ☁️ Deployment

This project supports multiple deployment targets. **Vercel** is the primary deployment method using a custom build script that fetches the statically linked `musl` Zola binary to ensure compatibility. 

### Primary: Vercel

1. Log in to Vercel and import this repository.
2. The provided `vercel.json` and `vercel-build.sh` files will automatically handle the build process, including strict version verification and output validation.
3. Once deployed, verify that `https://<project>.vercel.app` returns HTTP 200 and all assets (CSS, JS, Images, Fonts, Blog, Impossible List, CV, RSS, Sitemap, Search Index) work correctly.

### Secondary: Cloudflare Pages

Cloudflare Pages provides first-class support for static sites and native Ubuntu build environments.
**To deploy:**
1. Log in to [Cloudflare Pages](https://pages.cloudflare.com/).
2. Click **Create a project** -> **Connect to Git** and select this repository.
3. Configure the build settings:
   - **Framework preset:** `None`
   - **Build command:** `zola build`
   - **Build output directory:** `public`
4. Click **Save and Deploy**.

### Secondary: Netlify

The repository includes a `netlify.toml` file pre-configured for Zola 0.22.1.
**To deploy:**
1. Log in to [Netlify](https://app.netlify.com/).
2. Click **Add new site** -> **Import an existing project**.
3. Select this repository. Netlify will automatically read `netlify.toml`.
4. Click **Deploy Site**.

### Automated Workflow
Deployments are completely automated. Once the project is connected to Cloudflare Pages (or Netlify), the workflow is simply:
```bash
git add .
git commit -m "Update portfolio"
git push origin main
```
The platforms will automatically detect the push, run the build command, process images, and update `https://syedzubyl.space` without any manual FTP or uploads required.

---

## 📝 Content Management

### 1. Blog (`content/blog/`)
To add a new blog post:
1. Create a new folder inside `content/blog/` (e.g., `2024-12-01-my-new-post`).
2. Inside that folder, create an `index.md` file.
3. Add the frontmatter and content:
   ```toml
   +++
   title = "My New Post"
   date = 2024-12-01
   description = "A short description of the post."
   [taxonomies]
   tags = ["tag1", "tag2"]
   +++
   Your markdown content goes here!
   ```
4. If you have images, place them in the same folder and use the `img` shortcode: `{{ img(path="image.png", caption="My image") }}`.

### 2. Impossible List (`content/impossiblelist.md`)
The impossible list uses custom `extra` variables in the frontmatter to define categories and items.
Simply open `content/impossiblelist.md` and add or modify the items in the `[extra]` section.

### 3. Adding Projects (Home Page)
The projects listed on the home page are managed in the `content/_index.md` file.
Scroll down to `[[extra.projects]]` and duplicate an existing block to add a new project, filling out the title, date, links, tags, and description.

### 4. Updating the CV
1. Replace the `static/assets/Syed_Zubyl_N.pdf` file with your new PDF. Ensure the filename matches exactly so the existing links don't break.
2. The changes will go live automatically on your next `git push`.

### 5. Updating the Timeline
The timeline entries are also located in the frontmatter of `content/_index.md` under the `[[extra.timeline]]` block. Add new entries at the top of the list to keep it chronological.

---

*Generated as part of the Cloudflare Pages Migration and Deployment Fix.*