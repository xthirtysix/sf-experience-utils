/**
 * Created by x36 on 17.06.2023.
 */

public with sharing class CustomLabelService {
    final private static String ERROR_MESSAGE_NULL_TEMPLATE = 'Can not get Custom Label of null/empty string';
    final private static String ERROR_MESSAGE_NOT_FOUND_TEMPLATE = 'Custom Label {0} does not exist in the org';
    final private static String ORG_NAMESPACE = getOrgNamespace();
    final private static String USER_LOCALE = UserInfo.getLanguage();

    public static LabelListWrapper getLabelsByApiNames(String[] apiNames) {
        LabelListWrapper result = new LabelListWrapper();

        for (String apiName : apiNames) {
            try {
                result.labels.add(System.Label.get(ORG_NAMESPACE, apiName, USER_LOCALE));
            } catch (Exception e) {
                result.addError(apiName);
            }
        }

        return result;
    }

    public static LabelMapWrapper getClientKeyToLabelMap(Map<String, String> clientKeyToLabelApiName) {
        LabelMapWrapper result = new LabelMapWrapper();

        for (String clientKey : clientKeyToLabelApiName.keySet()) {
            String apiName = clientKeyToLabelApiName.get(clientKey);

            try {
                result.labels.put(clientKey, System.Label.get(ORG_NAMESPACE, apiName, USER_LOCALE));
            } catch (Exception e) {
                result.addError(apiName);
            }
        }

        return result;
    }

    private static String getOrgNamespace() {
        return [SELECT NamespacePrefix FROM Organization].NamespacePrefix;
    }

    abstract public class AbstractLabelWrapper {
        final private String[] abstractErrors;

        public AbstractLabelWrapper() {
            this.abstractErrors = new List<String>();
        }

        public virtual void addError(String apiName) {
           this.abstractErrors.add(
                   apiName == null || apiName == ''
                           ? ERROR_MESSAGE_NULL_TEMPLATE
                           : String.format(ERROR_MESSAGE_NOT_FOUND_TEMPLATE, new List<String>{apiName})
           );
        }
    }

    public class LabelListWrapper extends AbstractLabelWrapper {
        @AuraEnabled
        public String[] labels;
        @AuraEnabled
        public String[] errors;

        public LabelListWrapper() {
            this.labels = new List<String>();
            this.errors = this.abstractErrors;
        }
    }

    public class LabelMapWrapper extends AbstractLabelWrapper {
        @AuraEnabled
        public Map<String, String> labels;
        @AuraEnabled
        public String[] errors;

        public LabelMapWrapper() {
            this.labels = new Map<String, String>();
            this.errors = this.abstractErrors;
        }
    }
}
