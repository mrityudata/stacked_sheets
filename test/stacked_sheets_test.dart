import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:stacked_sheets/stacked_sheets.dart';

void main() {
  group('StackedSheetController Tests', () {
    test('Initial state should have no sheets', () {
      final controller = StackedSheetController();
      expect(controller.sheets.isEmpty, true);
      expect(controller.hasSheets, false);
    });

    test('Pushing a sheet should update the controller state', () {
      final controller = StackedSheetController();
      final testSheet = StackedSheet(child: const SizedBox());

      controller.push(testSheet);

      expect(controller.sheets.length, 1);
      expect(controller.hasSheets, true);
      expect(controller.sheets.first, testSheet);
    });

    test('Popping a sheet should remove the last added sheet', () {
      final controller = StackedSheetController();
      final sheet1 = StackedSheet(child: const SizedBox());
      final sheet2 = StackedSheet(child: const SizedBox());

      controller.push(sheet1);
      controller.push(sheet2);
      expect(controller.sheets.length, 2);

      controller.pop();

      expect(controller.sheets.length, 1);
      expect(controller.sheets.first, sheet1);
    });

    test('Should respect maxSheets limit', () {
      final controller = StackedSheetController(maxSheets: 2);
      final sheet = StackedSheet(child: const SizedBox());

      controller.push(sheet);
      controller.push(sheet);
      controller.push(sheet); // This should be ignored

      expect(controller.sheets.length, 2);
    });
  });
}