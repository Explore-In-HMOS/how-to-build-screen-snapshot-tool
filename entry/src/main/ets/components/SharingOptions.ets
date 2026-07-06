@Builder
export function SharingOptionsBuilder(componentId: string) {
  SharingOptions({
    componentId: componentId
  })
}

@ComponentV2
struct SharingOptions {
  @Require @Param componentId: string

  build() {
    Column() {
      Text('Share With')

      Button('Bluetooth')
        .width('100%')
        .height(20)
        .padding(8)
        .borderRadius(8)
        .backgroundColor($r('sys.color.gray_02'))

      Button('Send to Phone')
        .width('100%')
        .height(20)
        .padding(8)
        .borderRadius(8)
        .backgroundColor($r('sys.color.gray_02'))

      Button('Save')
        .width('100%')
        .height(20)
        .padding(8)
        .borderRadius(8)
        .backgroundColor($r('sys.color.gray_02'))
    }
    .backgroundColor($r('sys.color.gray_01'))
    .padding(16)
  }
}