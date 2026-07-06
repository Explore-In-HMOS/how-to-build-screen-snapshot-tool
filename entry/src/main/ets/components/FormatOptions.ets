import { SelectOptions } from '@kit.ArkUI'
import { saveImage } from '../common/ImageUtils'
import { MyOverlayManager } from '../common/OverlayManager'

@Builder
export function FormatOptionsBuilder(componentId: string) {
  FormatOptions({
    componentId: componentId
  })
}

@Component
struct FormatOptions {
  @Require @Prop componentId: string = ''
  @State sliderValue: number = 90
  @State selectedFormat: string = ''

  formatOptions: SelectOption[] = [
    {
      value: 'png'
    },
    {
      value: 'jpeg'
    }
  ]

  aboutToAppear(): void {
    this.selectedFormat = this.formatOptions[0].value.toString()
  }

  build() {
    Column({space: 4}) {
      Text('Options')

      Select(this.formatOptions)
        .selected(0)
        .value($$this.selectedFormat)

      if(this.selectedFormat === 'jpeg') {
        Column() {
          Text(`Quality ${this.sliderValue}`)
          Slider({
            value: this.sliderValue
          })
            .onChange((value) => {
              this.sliderValue = value
            })
            .slideRange({ from: 0, to: 100 })
        }
      }

      Button('OK')
        .width('100%')
        .padding(8)
        .margin({ top: 8 })
        .borderRadius(8)
        .backgroundColor($r('sys.color.select_normal_bg_color'))
        .onClick(() => {
          let context: UIContext = this.getUIContext()
          let om = MyOverlayManager.getInstance()
          saveImage(context, this.componentId, {
            quality: this.sliderValue,
            format: this.selectedFormat as 'png' | 'jpeg'
          })
          om.hideFormatOptionsOverlay(context)
          om.removeOverlay(context)
        })
    }
    .backgroundColor($r('sys.color.ohos_fa_background_dark'))
    .padding(16)
  }
}