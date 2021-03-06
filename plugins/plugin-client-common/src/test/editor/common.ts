/*
 * Copyright 2018-2020 IBM Corporation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { strictEqual } from 'assert'
import { ReplExpect, Selectors, Util } from '@kui-shell/test'

/** grab focus for the editor */
const grabFocus = async (res: ReplExpect.AppAndCount) => {
  const selector = `${Selectors.SIDECAR(res.count)} .monaco-editor-wrapper .view-lines`
  await res.app.client.click(selector).then(() => res.app.client.waitForEnabled(selector))
}

/** set the monaco editor text */
export const setValue = async (res: ReplExpect.AppAndCount, text: string): Promise<void> => {
  await res.app.client.waitForExist(Selectors.SIDECAR_MODE_BUTTON(res.count, 'Clear'))
  await res.app.client.click(Selectors.SIDECAR_MODE_BUTTON(res.count, 'Clear'))

  const txt = await Util.getValueFromMonaco(res)
  strictEqual(txt, '')

  await grabFocus(res)
  await res.app.client.keys(text)

  const txt2 = await Util.getValueFromMonaco(res)
  strictEqual(txt2, text)
}
