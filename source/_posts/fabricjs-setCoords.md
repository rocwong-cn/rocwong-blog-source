---
title: 为什么改变了形状的left或者top值以后，无法点击到这个形状了
tags:
  - canvas
categories:
  - fabricjs
date: 2019-09-13 11:02:03
---

## 状况分析：

在通过canvas来绘制滚动条的时候，由于滑块需要频繁的进行滚动，所以需要对其`left` 值进行更新，但是当视图部分进行频繁的拖动后发现：虽然滑块位置正确，但是却无法拖动滑块进行移动了，debug发现滑块的实际位置并不在所显示的位置上，原因是因为其各定点的坐标值没有被正确的计算。

## 解决方案：
在执行以下操作需要调用`object.setCoords()`：

``` js
object.set('left', 123)，object.setTop(456) 等等。
object.set('width', 100)， object.set('height', 100)
object.set('scaleX', 1.5)， object.set('scaleY', 1.5)
object.set('skewX', 20)， object.set('skewY', 20)
object.set('padding', 10)
object.set('angle', 45)
object.set('strokeWidth', 12)
object.center()，object.centerH()，object.centerV()
canvas.zoomToPoint(...)
```

## object.setCoords() 做了什么

通过分析fabricjs源码发现，`setCoords`后主要是重新计算了一下该图形的坐标位置`coords`属性，其中包含图形的每个顶点坐标，通过更新坐标值及绝对位置来刷新图形的画布中的位置
``` js
/**
 * Calculates and returns the .coords of an object.
 * @return {Object} Object with tl, tr, br, bl ....
 * @chainable
 */
calcCoords: function(absolute) {
  var rotateMatrix = this._calcRotateMatrix(),
      translateMatrix = this._calcTranslateMatrix(),
      startMatrix = multiplyMatrices(translateMatrix, rotateMatrix),
      vpt = this.getViewportTransform(),
      finalMatrix = absolute ? startMatrix : multiplyMatrices(vpt, startMatrix),
      dim = this._getTransformedDimensions(),
      w = dim.x / 2, h = dim.y / 2,
      tl = transformPoint({ x: -w, y: -h }, finalMatrix),
      tr = transformPoint({ x: w, y: -h }, finalMatrix),
      bl = transformPoint({ x: -w, y: h }, finalMatrix),
      br = transformPoint({ x: w, y: h }, finalMatrix);
  if (!absolute) {
    var padding = this.padding, angle = degreesToRadians(this.angle),
        cos = fabric.util.cos(angle), sin = fabric.util.sin(angle),
        cosP = cos * padding, sinP = sin * padding, cosPSinP = cosP + sinP,
        cosPMinusSinP = cosP - sinP;
    if (padding) {
      tl.x -= cosPMinusSinP;
      tl.y -= cosPSinP;
      tr.x += cosPSinP;
      tr.y -= cosPMinusSinP;
      bl.x -= cosPSinP;
      bl.y += cosPMinusSinP;
      br.x += cosPMinusSinP;
      br.y += cosPSinP;
    }
    var ml  = new fabric.Point((tl.x + bl.x) / 2, (tl.y + bl.y) / 2),
        mt  = new fabric.Point((tr.x + tl.x) / 2, (tr.y + tl.y) / 2),
        mr  = new fabric.Point((br.x + tr.x) / 2, (br.y + tr.y) / 2),
        mb  = new fabric.Point((br.x + bl.x) / 2, (br.y + bl.y) / 2),
        mtr = new fabric.Point(mt.x + sin * this.rotatingPointOffset, mt.y - cos * this.rotatingPointOffset);
  }
  // if (!absolute) {
  //   var canvas = this.canvas;
  //   setTimeout(function() {
  //     canvas.contextTop.clearRect(0, 0, 700, 700);
  //     canvas.contextTop.fillStyle = 'green';
  //     canvas.contextTop.fillRect(mb.x, mb.y, 3, 3);
  //     canvas.contextTop.fillRect(bl.x, bl.y, 3, 3);
  //     canvas.contextTop.fillRect(br.x, br.y, 3, 3);
  //     canvas.contextTop.fillRect(tl.x, tl.y, 3, 3);
  //     canvas.contextTop.fillRect(tr.x, tr.y, 3, 3);
  //     canvas.contextTop.fillRect(ml.x, ml.y, 3, 3);
  //     canvas.contextTop.fillRect(mr.x, mr.y, 3, 3);
  //     canvas.contextTop.fillRect(mt.x, mt.y, 3, 3);
  //     canvas.contextTop.fillRect(mtr.x, mtr.y, 3, 3);
  //   }, 50);
  // }
  var coords = {
    // corners
    tl: tl, tr: tr, br: br, bl: bl,
  };
  if (!absolute) {
    // middle
    coords.ml = ml;
    coords.mt = mt;
    coords.mr = mr;
    coords.mb = mb;
    // rotating point
    coords.mtr = mtr;
  }
  return coords;
}

/**
 * Sets corner position coordinates based on current angle, width and height.
 * See {@link https://github.com/kangax/fabric.js/wiki/When-to-call-setCoords|When-to-call-setCoords}
 * @param {Boolean} [ignoreZoom] set oCoords with or without the viewport transform.
 * @param {Boolean} [skipAbsolute] skip calculation of aCoords, useful in setViewportTransform
 * @return {fabric.Object} thisArg
 * @chainable
 */
setCoords: function(ignoreZoom, skipAbsolute) {
  this.oCoords = this.calcCoords(ignoreZoom);
  if (!skipAbsolute) {
    this.aCoords = this.calcCoords(true);
  }
  // set coordinates of the draggable boxes in the corners used to scale/rotate the image
  ignoreZoom || (this._setCornerCoords && this._setCornerCoords());
  return this;
}
```