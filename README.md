# [AWDevelopment](https://www.getawd.com)

A personal web app. A digital workspace for tasks, goals, rewards, planning, and whatever else I decide to build.

This is not a polished product. It is an ongoing Rails project where I design, break, and rebuild real systems as I learn. Some personal background and side projects live in the Blog and Projects sections. Releases are versioned and tracked in the changelog for anyone interested in the technical evolution of the app.

---

## Features

- Task system with priorities, recurring goals, and daily task levels
- Deterministic daily and task scoped rewards system
- Monthly and daily calendar views
- Ideas → Goals → Tasks → Rewards hierarchy
- Private file storage using Amazon S3 with presigned URLs
- Custom UI and layout system

---

## Built With

- Ruby on Rails
- PostgreSQL
- Amazon S3 (private + public objects, presigned access)
- Simple Calendar
- Devise
- Custom SCSS

---

## Storage Architecture

- Files are stored in S3
- Database stores filenames only, never full URLs
- Object keys are generated dynamically based on model IDs
- Private files are served using temporary presigned URLs via `S3Service` and `S3Helper`
- IAM permissions are scoped per application

---

## Changelog

For updates and technical changes, see the [CHANGELOG.md](./CHANGELOG.md).
