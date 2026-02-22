---
title: View Types
---

# View Types

ArchTect supports the full set of Structurizr view types. Each view is defined in the DSL and rendered on the canvas. This page describes what each type is for and how to set it up.

> Placeholder: Screenshot of the view list with the view type icons

---

## System Landscape

**Purpose:** Shows all people and software systems across the entire enterprise or portfolio. Good as a starting point or a high-level overview.

**DSL:**
```text
systemLandscape {
    include *
    autoLayout
}
```

- Use `include *` to automatically pull in all defined software systems and people.
- Add explicit `include <elementId>` lines to limit scope.

> Placeholder: Screenshot of a system landscape diagram

---

## System Context

**Purpose:** Focuses on a single software system and shows everything that interacts with it — people and external systems.

**DSL:**
```text
systemContext <softwareSystemId> {
    include *
    autoLayout
}
```

- The subject system is always shown at the center.
- `include *` adds all directly related elements.

> Placeholder: Screenshot of a system context diagram

---

## Container

**Purpose:** Zooms into a software system and shows the containers (applications, services, databases) that make it up.

**DSL:**
```text
container <softwareSystemId> {
    include *
    autoLayout
}
```

- Containers are defined inside the software system in your model.
- External systems and people that interact with the containers are included automatically with `*`.

> Placeholder: Screenshot of a container diagram

---

## Component

**Purpose:** Zooms into a single container and shows its internal components.

**DSL:**
```text
component <containerId> {
    include *
    autoLayout
}
```

- Components must be defined inside the container in the model.
- Use sparingly — component diagrams get outdated fast.

> Placeholder: Screenshot of a component diagram

---

## Dynamic

**Purpose:** Shows a sequence of interactions between elements to illustrate a specific scenario or use case. Render order is explicit — you define numbered steps.

**DSL:**
```text
dynamic <scope> {
    <elementA> -> <elementB> "Step description"
    <elementB> -> <elementC> "Next step"
    autoLayout
}
```

- `<scope>` can be a software system, container, or `*` for landscape scope.
- Steps are numbered automatically in the order they appear.
- The toolbar adds playback controls so you can step through the scenario.

> Placeholder: GIF showing dynamic step playback

### Sequence diagrams

Add `properties { flowType sequence }` (or `flowType sequence` depending on your DSL version) to render the dynamic view as a sequence diagram instead of a box-and-arrow diagram.

```text
dynamic <scope> {
    properties {
        flowType sequence
    }
    <elementA> -> <elementB> "Login request"
    <elementB> -> <elementC> "Validate token"
}
```

- Participants appear as columns.
- Messages render as horizontal arrows between columns.
- The toolbar switches to sequence-specific zoom and export controls.

> Placeholder: Screenshot of side-by-side dynamic view vs sequence diagram

---

## Filtered

**Purpose:** Creates a derived view by including or excluding elements from a base view based on tags. Lets you show different "cuts" of the same model without duplicating definitions.

**DSL:**
```text
filtered "<baseViewKey>" include tag "<tagName>" {
    title "..."
}
```

or to exclude:

```text
filtered "<baseViewKey>" exclude tag "<tagName>" {
    title "..."
}
```

**Common use cases:**

| Goal | Tag strategy |
|---|---|
| Compliance vs non-compliance | Tag non-compliant elements with `non-compliant` and exclude |
| Internal vs external | Tag external elements and show/hide them |
| Ownership boundaries | Tag by team and filter per team |

> Placeholder: Before/after comparison showing base view vs filtered view

---

## Deployment

**Purpose:** Shows runtime infrastructure — deployment nodes (servers, clusters, cloud regions), container instances, and their relationships. Typically one view per environment (dev, staging, production).

**DSL model:**
```text
deploymentEnvironment "Production" {
    deploymentNode "AWS" {
        deploymentNode "us-east-1" {
            containerInstance <containerId>
        }
    }
}
```

**DSL view:**
```text
deployment * "Production" {
    include *
    autoLayout
}
```

- The first argument (`*` or a software system ID) scopes which container instances appear.
- The second argument is the environment name.
- Use deployment groups if you need to control which relationships are replicated across instances.
- Keep naming consistent across environments so views are easy to compare.

> Placeholder: Screenshot of a deployment view showing nodes and instances

---

## Custom

**Purpose:** A free-form view not tied to a specific C4 level. Useful for cross-cutting concerns, technology views, or any diagram that doesn't fit the standard hierarchy.

**DSL:**
```text
custom {
    include <elementId1> <elementId2>
    autoLayout
}
```

- You explicitly control what appears — there is no automatic scope.
- Supports the same include/exclude syntax as other views.

> Placeholder: Screenshot of a custom view

---

## Image

**Purpose:** Displays an embedded diagram from an external source — PlantUML, Mermaid, Kroki, or a direct image URL — as a view in ArchTect.

**DSL:**
```text
image * {
    plantuml <path-or-url>
    // or: mermaid <path-or-url>
    // or: kroki <format> <path-or-url>
    // or: image <url>
}
```

- Rendering depends on the ArchTect build and whether the corresponding renderer is enabled.
- The canvas shows the rendered image; the inspector has no editable fields for image views.

> Placeholder: Screenshot of an image view showing a PlantUML diagram
