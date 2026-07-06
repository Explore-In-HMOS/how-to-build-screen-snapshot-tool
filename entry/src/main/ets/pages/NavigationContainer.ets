import { MyOverlayManager } from '../common/OverlayManager'
import { IndexPageBuilder } from './Index'

@Entry
@Component
struct NavigationContainer {
  @State showOverlay: boolean = false
  @Provide('pageStack') pageStack: NavPathStack = new NavPathStack()

  @Builder
  pageMap(builderName: string, param: object) {
    if (builderName === 'Index') {
      IndexPageBuilder()
    }
  }

  aboutToAppear(): void {
    this.pageStack.pushPathByName('Index', null)
  }

  build() {
    Stack() {

      Navigation(this.pageStack) {
      }
      .onAppear(() => {
        MyOverlayManager.getInstance().overlayHandler = (status: boolean) => {
          this.showOverlay = status
        }
      })
      .mode(NavigationMode.Stack)
      .navDestination(this.pageMap)
      .hideTitleBar(true)
      .padding(0)

      if(!this.showOverlay) {
        Button() {
          SymbolGlyph($r('sys.symbol.frame_overlay_rectify'))
            .fontColor([$r('sys.color.white')])
        }
        .width(32)
        .height(32)
        .backgroundColor(Color.Gray)
        .fontWeight(16)
        .margin({ bottom: 32, right: 24 })
        .position({ bottom: 0, right: 20})
        .shadow({ radius: 8, color: Color.Black, offsetX: 0, offsetY: 4 })
        .onClick(() => {
          MyOverlayManager.getInstance().showScreenshotOverlay(this.getUIContext())
        })
      }
    }
  }
}