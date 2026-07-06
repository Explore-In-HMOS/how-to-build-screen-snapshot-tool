import { ComponentContent, OverlayManager, UIContext } from '@kit.ArkUI'
import { FormatOptionsBuilder } from '../components/FormatOptions'
import { buildHighlight, HighlightParams } from '../components/Highlighter'
import { ScreenshotOverlayBuilder } from '../components/ScreenshotOverlay'
import { SharingOptionsBuilder } from '../components/SharingOptions'
import { saveImage } from './ImageUtils'
import { hilog } from '@kit.PerformanceAnalysisKit'

export class MyOverlayManager {
  private static instance: MyOverlayManager

  private constructor() {}

  private content: ComponentContent<Object> | null = null
  private highlightContent: ComponentContent<HighlightParams> | null = null
  private formatOptionsComponent: ComponentContent<string> | null = null
  private sharingOptionsComponent: ComponentContent<string> | null = null


  private selectedComponentId: string | null = null

  private isOverlayActive: boolean = false

  overlayHandler: (status: boolean) => void = (_) => {}

  private highlightParams: HighlightParams = {
    x: 0,
    y: 0,
    width: 0,
    height: 0
  }

  getOverlayStatus(): boolean {
    return this.isOverlayActive
  }

  getSelectedComponentId(): string | null {
      return this.selectedComponentId
  }

  static getInstance(): MyOverlayManager {
    if (!MyOverlayManager.instance) {
      MyOverlayManager.instance = new MyOverlayManager()
    }
    return MyOverlayManager.instance
  }

  showScreenshotOverlay(context: UIContext) {
    if(!this.content) {
      this.content = new ComponentContent(
        context,
        wrapBuilder(ScreenshotOverlayBuilder)
      )
    }
    this.updateOverlayStatus(true)
    context.getOverlayManager().addComponentContent(this.content, 1)
  }

  showFormatOptionsOverlay(context: UIContext, componentId: string) {
    this.formatOptionsComponent = new ComponentContent(
      context,
      wrapBuilder(FormatOptionsBuilder),
      componentId
    )

    context.getOverlayManager().addComponentContent(this.formatOptionsComponent, 3)
  }

  hideFormatOptionsOverlay(context: UIContext) {
    context.getOverlayManager().removeComponentContent(this.formatOptionsComponent)
  }

  showSharingOptionsOverlay(context: UIContext, componentId: string) {
    this.sharingOptionsComponent = new ComponentContent(
      context,
      wrapBuilder(SharingOptionsBuilder),
      componentId
    )

    context.getOverlayManager().addComponentContent(this.sharingOptionsComponent, 4)
  }

  hideSharingOptionsOverlay(context: UIContext) {
    context.getOverlayManager().removeComponentContent(this.sharingOptionsComponent)
  }

  removeOverlay(context: UIContext) {
    this.updateOverlayStatus(false)
    this.resetHighlightParams(context)
    if(this.content) {
      context.getOverlayManager().removeComponentContent(this.content)
      this.content = null
    }
  }

  private updateOverlayStatus(status: boolean) {
    this.isOverlayActive = status
    this.overlayHandler(status)
  }

  showHighlighter(context: UIContext, componentId: string) {
    try {
      this.resetHighlightParams(context)
      const info = context.getComponentUtils().getRectangleById(componentId)
      this.highlightParams = {
        x: context.px2vp(info.screenOffset.x),
        y: context.px2vp(info.screenOffset.y),
        width: context.px2vp(info.size.width),
        height: context.px2vp(info.size.height)
      }

      this.highlightContent = new ComponentContent(
        context,
        wrapBuilder(buildHighlight),
        this.highlightParams,
      )
      this.selectedComponentId = componentId

      context.getOverlayManager().addComponentContent(this.highlightContent, 0)

    } catch (error) {
      hilog.info(0, error, null);
    }
  }

  resetHighlightParams(context: UIContext) {
    if(this.highlightContent) {
      context.getOverlayManager().removeComponentContent(this.highlightContent)
      this.selectedComponentId = null
      this.highlightParams = {
        x: 0,
        y: 0,
        width: 0,
        height: 0
      }
    }
  }
}

