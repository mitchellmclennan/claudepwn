---
name: gitnexus-exploring
description: "Use when the user asks how code works, wants to understand architecture, or is exploring an unfamiliar part of the codebase."
---

# GitNexus: Exploring Code

## When to Use

- "How does X work?"
- "What's the architecture of this module?"
- "Walk me through the flow of Y"
- Onboarding to a new area of the codebase

## Workflow

1. **Start broad:** Read `gitnexus://repo/{name}/clusters` to see all functional areas
2. **Zoom into the relevant cluster:** Read `gitnexus://repo/{name}/cluster/{clusterName}`
3. **Trace execution flows:** Read `gitnexus://repo/{name}/processes` to find relevant processes
4. **Follow a specific process:** Read `gitnexus://repo/{name}/process/{processName}` for step-by-step trace
5. **Deep dive on a symbol:** Use `gitnexus context({symbol: "functionName"})` for 360-degree view

## Checklist

- [ ] Identified which cluster(s) the code belongs to
- [ ] Traced at least one complete execution flow
- [ ] Identified cross-cluster dependencies
- [ ] Can explain the data flow from input to output
