import { image } from '@kit.ImageKit'
import { fileIo as fs } from '@kit.CoreFileKit'
import { common } from '@kit.AbilityKit'
import { UIContext, window } from '@kit.ArkUI'
import { hilog } from '@kit.PerformanceAnalysisKit'

export interface FormatOptionsParams {
  quality: number
  format: 'png' | 'jpeg'
}

export async function savePixelMapToFile(
  context: common.UIAbilityContext,
  pixelMap: PixelMap,
  format: 'png' | 'jpeg' = 'png',
  quality: number = 90
): Promise<string> {
  // 1. Pack PixelMap into a buffer
  const imagePacker = image.createImagePacker()
  const packOptions: image.PackingOption = {
    format: `image/${format}`,
    quality: quality  // only applies to JPEG
  }
  let buffer: ArrayBuffer = new ArrayBuffer(0)
  try {
    buffer = await imagePacker.packToData(pixelMap, packOptions)
  } catch (error) {
    hilog.error(0, error, null)
  }
  imagePacker.release()

  // 2. Write buffer to a file
  const filePath = `${context.filesDir}/${Date.now()}.${format}`
  let file: fs.File = null!;
  try {
    fs.openSync(filePath, fs.OpenMode.CREATE | fs.OpenMode.WRITE_ONLY)
    fs.writeSync(file.fd, buffer)
  } catch (e) {
    hilog.error(0, e, null)
  } finally {
    await fs.close(file)
  }

  return filePath  // use this path with Image('file://...')
}

export async function saveImage(context: UIContext, componentId: string, params: FormatOptionsParams) {
  const pixelMap = await context.getComponentSnapshot().get(componentId)

  await savePixelMapToFile(context.getHostContext() as common.UIAbilityContext, pixelMap, params.format, params.quality)
}

export function captureWindowViaSideButton(context: UIContext) {
  window.getLastWindow(context.getHostContext(), (err, win) => {
    win.snapshot((error, pixelMap) => {
      if(!error) {
        savePixelMapToFile(context.getHostContext() as common.UIAbilityContext, pixelMap)
      }
    })
  })
}