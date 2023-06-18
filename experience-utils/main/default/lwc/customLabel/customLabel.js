/**
 * Created by x36 on 18.06.2023.
 */

import { api, LightningElement, wire } from 'lwc'
import getLabelsByApiNames from '@salesforce/apex/CustomLabelController.getLabelsByApiNames'

export default class CustomLabel extends LightningElement {
  @api customLabelApiName
  label

  @wire(getLabelsByApiNames, { apiNames: '$apiNames' })
  wiredLabel({ error, data }) {
    if (data?.labels) {
      this.label = data.labels[0]
    }

    if (data?.errors) {
      console.group('Custom Label warnings')

      for (const errorMessage of data.errors) {
        console.warn(errorMessage)
      }

      console.groupEnd()
    }

    if (error) {
      console.error(error)
    }
  }

  get apiNames() {
    return [ this.customLabelApiName, '', null, 'random_api_name' ]
  }
}