export interface HighlightParams {
  x: number
  y: number
  width: number
  height: number
}

@Builder
export function buildHighlight(params: HighlightParams) {
  RelativeContainer()
    .position({ x: params.x, y: params.y })
    .width(params.width)
    .height(params.height)
    .border({ width: 2, color: Color.Red, radius: 6 })
    .hitTestBehavior(HitTestMode.Transparent)

}