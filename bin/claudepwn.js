#!/usr/bin/env node

/**
 * claudepwn — One command to set up Claude Code automation for any project.
 *
 * This is a thin Node.js wrapper that resolves the package directory
 * and calls init.sh with all arguments forwarded.
 *
 * Usage:
 *   npx claudepwn new --prd ./PRD.md --features all
 *   npx claudepwn init --prd ./PRD.md --features all
 *   npx claudepwn --help
 */

const { execFileSync } = require("child_process");
const path = require("path");

const packageRoot = path.resolve(__dirname, "..");
const initScript = path.join(packageRoot, "init.sh");

try {
  execFileSync("bash", [initScript, ...process.argv.slice(2)], {
    stdio: "inherit",
    cwd: process.cwd(),
    env: { ...process.env, CLAUDEPWN_ROOT: packageRoot },
  });
} catch (err) {
  process.exit(err.status || 1);
}
