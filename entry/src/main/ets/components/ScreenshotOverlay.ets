import { saveImage } from '../common/ImageUtils'
import { MyOverlayManager } from '../common/OverlayManager'

@Builder
export function ScreenshotOverlayBuilder() {
  ScreenshotOverlay()
    .hitTestBehavior(HitTestMode.Transparent)
}

@Component
struct ScreenshotOverlay {
  @State isOnTop: boolean = true

  build() {
    Stack({ alignContent: Alignment.Center }) {
      Row({ space: 8 }) {
        Button() {
          SymbolGlyph($r('sys.symbol.camera'))
            .fontColor([$r('sys.color.white')])
        }
        .width(30)
        .height(30)
        .borderRadius(40)
        .onClick(() => {
          let om = MyOverlayManager.getInstance()
          let id = om.getSelectedComponentId()
          if(id) {
            om.showFormatOptionsOverlay(this.getUIContext(), id)
          }
        })

        Button() {
          SymbolGlyph($r(this.isOnTop ? 'sys.symbol.chevron_down' : 'sys.symbol.chevron_up'))
            .fontColor([$r('sys.color.white')])
        }
        .width(30)
        .height(30)
        .borderRadius(40)
        .onClick(() => {
          this.isOnTop = !this.isOnTop
        })

        Button() {
          SymbolGlyph($r('sys.symbol.xmark_circle'))
            .fontColor([$r('sys.color.white')])
        }
        .width(30)
        .height(30)
        .borderRadius(40)
        .onClick(() => {
          MyOverlayManager.getInstance().removeOverlay(this.getUIContext())
        })
      }
      .justifyContent(FlexAlign.Center)
      .margin({ top: this.isOnTop ? 0 : '80%', bottom: this.isOnTop ? '80%' : 0 })
      .animation({ duration: 300, curve: Curve.EaseInOut })
    }
    .width('100%')
    .height('100%')
    .hitTestBehavior(HitTestMode.Transparent)
    .onDisAppear(() => {
      MyOverlayManager.getInstance().removeOverlay(this.getUIContext())
    })
  }
}


