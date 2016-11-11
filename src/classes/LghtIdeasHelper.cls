public class LghtIdeasHelper{
    public static List<Map<String, String>> getCategoryOptions(String source, String zoneName) {
        List<Map<String, String>> listArray = new List<Map<String, String>>();
        Map<String, String> listItem;
        List<String> catZones;
        Boolean containZone;

        if (source == 'Custom settings') {
            List<LghtIdeasCategories__c> rows = [SELECT Name, Label__c, Parent__c, Zone__c FROM LghtIdeasCategories__c LIMIT 1000];

            for (LghtIdeasCategories__c row : rows) {
                if (zoneName != null && zoneName != '') {
                    if (row.Zone__c == null) continue;

                    catZones = String.valueOf(row.Zone__c).split(',');
                    containZone = false;

                    for (String zn : catZones) {
                        if (zn == zoneName) containZone = true;
                    }

                    if (!containZone) continue;
                }

                listItem = new Map<String, String>();
                listItem.put('value', row.Name);
                listItem.put('label', row.Label__c);
                listItem.put('parent', row.Parent__c);
                listArray.add(listItem);
            }
        } else {
            Schema.DescribeFieldResult fieldResult = Idea.Categories.getDescribe();
            List<Schema.PicklistEntry> categoryPicklistEntries = fieldResult.getPicklistValues();

            for (Schema.PicklistEntry item : categoryPicklistEntries) {
                listItem = new Map<String, String>();
                listItem.put('value', item.getValue());
                listItem.put('label', item.getLabel());
                listArray.add(listItem);
            }
        }

        return listArray;
    }


    public static List<Map<String, String>> getStatusOptions() {
        List<Map<String, String>> listArray = new List<Map<String, String>>();
        Map<String, String> listItem;
        Schema.DescribeFieldResult fieldResult = Idea.Status.getDescribe();
        List<Schema.PicklistEntry> statusPicklistEntries = fieldResult.getPicklistValues();

        for (Schema.PicklistEntry item : statusPicklistEntries) {
            listItem = new Map<String, String>();
            listItem.put('value', item.getValue());
            listItem.put('label', item.getLabel());
            listArray.add(listItem);
        }

        return listArray;
    }


    public static String compileWhereStatement(String communityName, Map<String, String> filterData) {
        String userId = UserInfo.getUserId();
        Id communityId = LghtIdeasHelper.getCommunityId(communityName);
        List<String> whereList = new List<String>();
        List<String> searchIds;
        String searchQuery, category, status, ideaTheme, showBy;

        if (filterData == null) return '';

        searchQuery = filterData.get('search');
        category = filterData.get('category');
        status = filterData.get('status');
        ideaTheme = filterData.get('idea_theme');
        showBy = filterData.get('showBy');

        if (String.isNotBlank(category))
            whereList.add('Categories INCLUDES (\'' + String.escapeSingleQuotes(category) + '\')');

        if (String.isNotBlank(status))
            whereList.add('Status = \'' + String.escapeSingleQuotes(status) + '\'');

        if (String.isNotBlank(ideaTheme))
            whereList.add('IdeaThemeID = \'' + String.escapeSingleQuotes(ideaTheme) + '\'');

        if (String.isNotBlank(showBy)) {
            if (showBy == 'createdByMe') {
                whereList.add('CreatedById = \'' + userId + '\'') ;
            } else if (showBy == 'commentedByMe') {
                searchIds = new List<String>();

                List<AggregateResult> res = [SELECT IdeaId FROM IdeaComment WHERE CommunityId = :communityId AND CreatedById = :userId GROUP BY IdeaId];

                for (AggregateResult resRow : res) {
                    searchIds.add(String.valueOf(resRow.get('IdeaId')));
                }

                whereList.add('Id IN (\'' + String.join(searchIds, '\',\'') + '\')');
            }
        }

        if (String.isNotBlank(searchQuery)) {
            searchIds = new List<String>();
            List<List<SObject>> searchList = [FIND :searchQuery IN ALL FIELDS RETURNING Idea(Id) LIMIT 50];

            for (SObject obj : searchList[0]) {
                searchIds.add(obj.Id);
            }

            whereList.add('Id IN (\'' + String.join(searchIds, '\',\'') + '\')');
        }

        return String.join(whereList, ' AND ');
    }


    public static String compileOrderByStatement(String orderByData) {
        String orderByClause = 'CreatedDate DESC';

        if (String.isNotBlank(orderByData)) {
            if (orderByData == 'Trending') {
                orderByClause = 'LastCommentDate DESC NULLS LAST, CreatedDate DESC';
            } else if (orderByData == 'Popular') {
                orderByClause = 'VoteTotal DESC, CreatedDate DESC';
            }
        }

        return orderByClause;
    }


    public static String getCommunityId(String communityName) {
        if (String.isBlank(communityName)) {
            communityName = LghtIdeasHelper.getConfigValue('Viktor Test Community');
        }

        if (communityName == '') {
            System.debug('Cannot find community name within settings');
            return '';
        }

        try {
            Community community = [SELECT Id FROM Community WHERE Name = :communityName LIMIT 1];
            return community.Id;
        } catch (Exception e) {
            System.debug('No communities with name "' + communityName + '"');
        }

        return '';
    }


    public static String getConfigValue(String name) {
        for (LghtIdeasSettings__c row : [SELECT Name, Value__c FROM LghtIdeasSettings__c LIMIT 100]) {
            if (row.Name == name) return row.Value__c;
        }

        return '';
    }


    public static void performAccessCheck(String accessType) {
        Schema.DescribeSObjectResult ideaDescribe = Idea.sObjectType.getDescribe();
        Schema.DescribeSObjectResult voteDescribe = Vote.sObjectType.getDescribe();
        Schema.DescribeSObjectResult commentDescribe = IdeaComment.sObjectType.getDescribe();

        if (!ideaDescribe.isAccessible()
                || (accessType == 'create' && !ideaDescribe.isCreateable())
                || (accessType == 'edit' && !ideaDescribe.isUpdateable())
                || (accessType == 'search' && !ideaDescribe.isSearchable()))
            throw new AuraHandledException('Access not granted');

        if (accessType == 'create_vote' && !voteDescribe.isAccessible()
                || accessType == 'create_vote' && !voteDescribe.isCreateable()) {
            throw new AuraHandledException('Access not granted');
        }

        if ((accessType == 'read_comments' && !commentDescribe.isAccessible())
                || (accessType == 'create_comments') && !commentDescribe.isCreateable()) {
            throw new AuraHandledException('Access not granted');
        }
    }
}