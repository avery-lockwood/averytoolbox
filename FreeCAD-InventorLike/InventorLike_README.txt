INVENTOR-LIKE FREECAD WORKFLOW PROFILE (with Onshape hotkeys)
=============================================================

Version 1.4.0 — based on the Fusion-like profile v1.3.0.

This profile restyles FreeCAD 1.1 with Autodesk Inventor terminology
(3D Model / Direct Edit / Project Geometry / Work Features / fx
Parameters / feature browser) and installs a context-sensitive
keyboard map that follows Onshape's default shortcuts.

WHAT IT INSTALLS
----------------
- Workspace selector styled after Inventor environments:
  3D MODEL, SURFACE, MESH, SHEET METAL, ASSEMBLE, DRAWING, CAM, STUDIO.
- Toolbars grouped as CREATE / MODIFY / CONSTRAIN / WORK FEATURES.
- Feature browser (timeline) dock along the bottom.
- Command palette: press S anywhere, type to search all commands.
- Inventor-style Hole & Thread dialogs (H, and Ctrl+Shift+T).
- fx Parameters: promote sketch dimensions to named document
  parameters stored on a "Parameters" VarSet (spreadsheet fallback).

fx PARAMETERS
-------------
1. In a sketch, create or select a dimension (distance, radius,
   diameter, or angle).
2. Press Shift+D, or click "fx Parameter" in the CONSTRAIN toolbar,
   or use menu Inventor-like > fx: Parameterize dimension.
3. Name the parameter (defaults to d<n>, Inventor-style). The
   dimension is bound by expression to Parameters.<name>.
4. Edit values later by selecting the "Parameters" object in the tree
   and changing its properties — every bound dimension follows.
   If no dimension is selected, the newest driving dimension is used,
   so the flow "place dimension, hit Shift+D, name it" just works.

KEYBOARD MAP (Onshape-style, context sensitive)
-----------------------------------------------
Everywhere:
  S           Command palette (search all commands)
  Shift+1..7  Front / Back / Left / Right / Top / Bottom / Isometric
  Esc         End projection picking (when active)

Modeling (no sketch open):
  Shift+S     New sketch
  E, Shift+E  Extrude menu (Join / Pad, Cut / Pocket)
  Shift+F     Fillet          H  Hole menu
  Q           Direct Edit menu (pad/pocket/thickness/draft)
  Ctrl+Shift+T  Independent Thread
  M / I       Measure         N  View normal to selection
  F           Zoom to fit     W  Zoom to window (box zoom)
  Z           Zoom out        Shift+Z  Zoom in
  Shift+X     Section view (see below)   Shift+T  Toggle transparency
  Shift+V     Hide selected   Shift+B  Show selected
  V           Toggle visibility
  P           Project into sketch workflows

Assembly extras:
  I           Insert component
  Ctrl+C/V    Copy / paste component instances
  Ctrl+Shift+V  Paste in place
  Ctrl+D      Duplicate selected components

Sketching (sketch in edit):
  L  Line                     R  Corner rectangle
  F  Center rectangle         C  Center circle
  A  3-point arc              Shift+A  Polyline (line/arc modes)
  O  Offset                   X  Trim
  Q  Toggle construction      D  Dimension
  Shift+D  fx Parameter (bind dimension to a named parameter)
  U or P  Project geometry    Shift+P  Project as reference
  Shift+S  Point              Shift+F  Sketch fillet
  T  Tangent                  I  Coincident
  H  Horizontal               V  Vertical
  B  Parallel                 Shift+L  Perpendicular
  =  Equal                    Shift+Q / Shift+M  Symmetric
  Shift+O  Concentric (unified coincident)
  Shift+J  Block (fix)

EXTRUDE A SKETCH REGION (Onshape-style partial extrude)
-------------------------------------------------------
Select the edges bounding part of a sketch (in the 3D view or the
Elements panel), then press E / Shift+E and pick Join or Cut. The
selected edges are bound into a PartDesign SubShapeBinder
("Region_<sketch>") and the Pad/Pocket runs on that binder instead of
the whole sketch. The binder stays linked, so editing the sketch
updates the feature. If the edges do not close a loop you get a
message instead of a broken feature. Unlike Onshape you pick the
region's boundary edges, not the region's interior.

PICK REGIONS BY CLICKING INSIDE THEM (E / Shift+R, Onshape-style)
-----------------------------------------------------------------
The E key is context-sensitive, Onshape-style. In both cases it ends
in ONE menu that handles everything: Join / Pad, Cut / Pocket,
Join / Revolution, Cut / Groove.
- INSIDE a sketch: E finishes the sketch and applies the chosen
  feature to the WHOLE sketch.
- OUTSIDE a sketch: E starts region picking on the selected sketch
  (or the newest visible one). Click INSIDE each area you want —
  crossing curves are split at their intersections, so lens-shaped
  in-between areas are pickable too. Each pick lights up orange.
  Enter finishes and shows the same menu; Esc cancels.
Revolving a picked region: the Revolution/Groove dialog will ask for
an axis (regions don't carry the sketch's own axes) — a straight
construction line in the sketch is an easy pick. Regions crossing
the axis will fail to revolve, as in any CAD.
  With sketch boundary edges already selected, E uses the
  SubShapeBinder flow instead; with no sketch anywhere, it falls
  back to the classic extrude menu.
Shift+R also starts region picking, and the Extrude dropdown has
"picked regions" rows that go straight to Pad or Pocket.

This creates a parametric SketchRegion object. On every recompute it
re-splits the sketch plane at all curve intersections and re-finds
"the region containing each clicked point" — the same seed-point
logic Onshape uses — so it follows sketch edits. If an edit moves a
seed point outside any enclosed area, that region is skipped with a
warning (all gone = feature errors and asks you to re-pick).
Open, unbounded areas cannot be picked; area must be fully enclosed.

SECTION VIEW (Shift+X, Onshape-style)
-------------------------------------
- Select any planar face or datum/origin plane, press Shift+X: the view
  is sectioned along that plane, with a manipulator you can drag to
  slide the cut through the model and a ball you can drag to tilt the
  plane to any angle. Press Shift+X again to exit. Note this is a
  graphics-only clip, so the cut is uncapped (hollow look).
- With nothing selected, Shift+X opens FreeCAD's native Persistent
  Section Cut instead (capped faces, but global X/Y/Z planes only).

COMPACT UI
----------
- The Tasks panel is a small floating overlay that appears over the
  3D view only while it has content (a task dialog or contextual
  panels), and auto-hides the moment it is empty.
- The feature browser (timeline) is a slim strip at the bottom.
  Hover it for usage hints; right-click features to roll back/forward.

NOTES
-----
- Internal identifiers (preferences path "FusionLike", module
  fusion_like_ui_runtime) are kept from the original profile so
  installing this version cleanly replaces / restores the old one.
- Menu: Inventor-like > Restore original FreeCAD interface undoes
  everything reversibly.
