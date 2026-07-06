// OverlayExample.ets
// Simple overlay with two action buttons using ArkUI
import { MyOverlayManager } from '../common/OverlayManager';
import { Callback } from '@kit.BasicServicesKit';
import { inputConsumer, KeyCode, KeyEvent } from '@kit.InputKit';
import { captureWindowViaSideButton } from '../common/ImageUtils';

@Builder
export function IndexPageBuilder() {
  Index()
}

@Component
struct Index {
  context: UIContext | null = null
  overlayManager: MyOverlayManager = MyOverlayManager.getInstance()
  @Consume('pageStack') pageStack: NavPathStack

  func: Callback<KeyEvent> = (event: KeyEvent): void => {
    captureWindowViaSideButton(this.getUIContext())
  }

  aboutToDisappear(): void {
    try {
      inputConsumer.off('keyPressed')
    } catch (error) {
      // TODO: Implement error handling.
    }
  }

  async checkForOverlayStatus(componentId: string, call: VoidCallback = () => {}) {
    if(!this.overlayManager.getOverlayStatus()) {
      call()
    } else {

      MyOverlayManager.getInstance().showHighlighter(this.context!,componentId)
    }
  }


  initializeWindowSnapshotListener() {
    let opts: inputConsumer.KeyPressedConfig =  {
      key: KeyCode.KEYCODE_POWER,
      action: 1,
      isRepeat: false
    }
    try {
      inputConsumer.on('keyPressed', opts, this.func)
    } catch (e) {

    }
  }

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.Center }) {
        Column({ space: 16 }) {
          Column({ space: 2 }) {
            Button('Text')
              .id('text')
              .height(40)
              .onClick(() => {
                this.checkForOverlayStatus('text')
              })
            Text('Codelab Overlay Manager Demo')
              .id('descr')
              .fontSize(12)
              .fontWeight(10)
              .onClick(() => {
                this.checkForOverlayStatus('descr')
              })
          }
          .id('col')
          .width(100)
          .onClick(() => {
            this.checkForOverlayStatus('col')
          })

          Button('Open Overlay')
            .id('overlay_button')
            .width(160)
            .height(48)
            .backgroundColor('#4F46E5')
            .fontColor(Color.White)
            .fontSize(15)
            .borderRadius(12)
            .onClick(() => {
              this.checkForOverlayStatus('overlay_button', () => {

                this.overlayManager.showScreenshotOverlay(this.context!)
              })
            })
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      }
      .id('page')
      .width('100%')
      .height('100%')
      .onClick(() => {
        this.checkForOverlayStatus('page')
      })
    }
    .hideTitleBar(true)
    .onReady(() => {
      this.context = this.getUIContext()
      this.initializeWindowSnapshotListener()
    })
    .padding(0)
  }
}
