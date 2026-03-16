# GymVoice Backend

This directory contains the GymVoice backend service implemented with Node.js, Express, and TypeScript.

## Prerequisites

- Node.js LTS (>= 20)
- npm (or a compatible package manager)

## Setup

Install dependencies:

```bash
cd backend
npm install
```

## Development

Run the development server with automatic reload:

```bash
npm run dev
```

The server listens on port `4000` by default. You can override it with the `PORT` environment variable.

### Health endpoint

Once the server is running, you can verify it with:

```bash
curl http://localhost:4000/health
```

Expected response:

```json
{ "status": "ok" }
```

## Scripts

- `npm run dev` — start the dev server (ts-node-dev)
- `npm run build` — build the TypeScript sources to `dist/`
- `npm run start` — run the built server from `dist/index.js`
- `npm run lint` — run ESLint on `src/**/*.ts`
- `npm run typecheck` — run the TypeScript compiler in no-emit mode
- `npm run test` — run unit tests with Vitest

## Testing

To run the backend tests:

```bash
npm test
```

The test suite includes a basic smoke test for the `/health` endpoint.

