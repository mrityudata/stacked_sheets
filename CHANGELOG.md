## 0.0.2

* Added `maxSheets` limit to `StackedSheetController` to prevent over-stacking.
* Updated `push` method to return a `bool` indicating whether the sheet was successfully added.
* Added initial state synchronization and lifecycle guards to `StackedSheetCoordinator`.

## 0.0.1

* Initial release of `stacked_sheets`.
* Core features:
    * Overlay-based sheet stacking.
    * Automatic 3D parallax scaling and dimming of background sheets.
    * `StackedSheetController` for imperative stack management.
    * `StackedSheetCoordinator` widget for easy integration.
    * Customizable background colors, border radius, and heights.
