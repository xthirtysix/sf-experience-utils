/**
 * Created by x36 on 17.06.2023.
 */

public with sharing class CustomLabelController {
    @AuraEnabled(Cacheable=true)
    public static CustomLabelService.LabelListWrapper getLabelsByApiNames(String[] apiNames) {
        System.debug(apiNames);
        return CustomLabelService.getLabelsByApiNames(apiNames);
    }

    @AuraEnabled(Cacheable=true)
    public static CustomLabelService.LabelMapWrapper getClientKeyToLabelMap(
            Map<String, String> clientKeyToLabelApiName
    ) {
        return CustomLabelService.getClientKeyToLabelMap(clientKeyToLabelApiName);
    }
}