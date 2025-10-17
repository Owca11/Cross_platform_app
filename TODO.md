# TODO: Improve Drawing Notes Functionality

## Tasks

- [ ] Add color picker for drawing: Introduce a `_drawingColor` variable (default black), add a color picker button next to the drawing area, and update `DrawingPainter` to use this color in `note_detail_screen.dart`.
- [ ] Make note backgrounds lighter: Change card color in `notes_screen.dart` from `Colors.pink.shade50` to `Colors.white.withOpacity(0.7)` for a lighter appearance.
- [ ] Fix drawing save/display: Clip drawing positions to the container bounds (0 to 300 height) during drawing in `note_detail_screen.dart`, and ensure the display in `notes_screen.dart` also clips to prevent overflow.
- [ ] Change save button: Replace the flower emoji with `Icon(Icons.save)` in the FAB in `note_detail_screen.dart`.
