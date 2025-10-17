# TODO: Improve Drawing Notes Functionality

## Tasks

- [x] Add color picker for drawing: Introduce a `_drawingColor` variable (default black), add a color picker button next to the drawing area, and update `DrawingPainter` to use this color in `note_detail_screen.dart`.
- [x] Make note backgrounds lighter: Change card color in `notes_screen.dart` from `Colors.pink.shade50` to `Colors.white.withOpacity(0.7)` for a lighter appearance.
- [x] Fix drawing save/display: Clip drawing positions to the container bounds (0 to 300 height) during drawing in `note_detail_screen.dart`, and ensure the display in `notes_screen.dart` also clips to prevent overflow.
- [x] Change save button: Replace the flower emoji with `Icon(Icons.save)` in the FAB in `note_detail_screen.dart`.
- [ ] Fix empty white space in note creation view: Apply gradient background to the entire screen in `note_detail_screen.dart`.
- [ ] Fix drawing color saving: Modify Note model to store colors per stroke, update DrawingPainter to render per-stroke colors, and fix positioning/clipping issues.
- [ ] Add eraser tool: Implement eraser functionality in the drawing area in `note_detail_screen.dart`.
