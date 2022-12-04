public with sharing class ganttChartRM {
    @AuraEnabled
    public static Map<String, Object> getChartData(String recordId, String startTime, String endTime, Integer slotSize, List<String> filterProjects, List<String> filterRoles, String filterStatus) {
        Id UserId = UserInfo.getUserId();
        Map<String, Object> data = new Map<String, Object>();
        String query = 'SELECT IT_Resource__c, IT_Resource__r.Name, IT_Resource__r.Active__c, IT_Resource__r.Roles__c, Life_Cycle__c, Life_Cycle__r.Name, Life_Cycle__r.Active__c, Life_Cycle__r.Color__c, Start_Date__c, End_Date__c, Status__c, Effort__c, Number_of_Hours__c FROM Team_Assignment__c WHERE Start_Date__c <= :endDate AND End_Date__c >= :startDate AND (Life_Cycle__c = NULL OR Life_Cycle__r.Active__c = TRUE) AND IT_Resource__r.Active__c = TRUE';
         
        List<Team_Assignment__c> allocations = new List<Team_Assignment__c>();
        Map<String, Object> projectById = new Map<String, Object>();
        Map<String, Object> resourceById = new Map<String, Object>();
        Set<String> roles = new Set<String>();

        if (!filterProjects.isEmpty()) {
            query += ' AND Life_Cycle__c IN :filterProjects';
        }
        /*
        if (!filterProjectRecords.isEmpty()) {
            query += ' AND Project__c IN :filterProjectRecords';
        }
        */
        if (!filterRoles.isEmpty()) {
            query += ' AND IT_Resource__r.Roles__c IN :filterRoles';
        }
        if (String.isNotEmpty(filterStatus)) {
            query += ' AND Status__c = :filterStatus';
        }

        if (String.isNotEmpty(startTime) &&  String.isNotEmpty(endTime)) {
            Date startDate = DateTime.newInstance(Long.valueOf(startTime)).date();
            
            Date endDate = DateTime.newInstance(Long.valueOf(endTime)).date();
            Integer days = startDate.daysBetween(endDate) + 1;
            slotSize = Integer.valueOf(slotSize);
            Decimal slots = days / slotSize;
            
            // Overview View
            if (String.isEmpty(recordId)) {
                query += ' AND (IT_Resource__r.OwnerId =: UserId OR IT_Resource__r.Employee__c =: UserId) ORDER BY IT_Resource__r.Name, Life_Cycle__r.Name NULLS FIRST, Start_Date__c';
                System.debug(query);
                System.debug(startTime);
                System.debug(endTime);
                System.debug(slotSize);
                allocations = Database.query(query);

                // display all active resources
                for (Object r : ganttChartRM.getResources()) {
                    Map<String, Object> resource = (Map<String, Object>)r;
                    resourceById.put((String)resource.get('Id'), new Map<String, Object> {
                        'Id' => resource.get('Id'),
                        'Name' => resource.get('Name'),
                        'Default_Role__c' => resource.get('Roles__c'),
                        'allocationsByProject' => new Map<String, Object>()
                    });
                }
            } else {
                if (Id.valueOf(recordId).getSobjectType().getDescribe().getName().endsWith('IT_Portfolio_Management__c')) {
                    data.put('projectId', recordId);
                }

                query += ' AND (Life_Cycle__c = :recordId OR IT_Resource__r.OwnerId = :UserId)';
                query += ' ORDER BY IT_Resource__r.Name, Life_Cycle__r.Name NULLS FIRST, Start_Date__c';

                allocations = Database.query(query);

                // empty state on resource page
                if (allocations.isEmpty() && Id.valueOf(recordId).getSobjectType().getDescribe().getName().endsWith('IT_Resource__c')) {
                    IT_Resource__c resource = [SELECT Id, Name, Active__c, Roles__c
                                            FROM IT_Resource__c
                                            WHERE Id = :recordId OR Owner.Id =:UserId];

                    resourceById.put(resource.Id, new Map<String, Object> {
                        'Id' => resource.Id,
                        'Name' => resource.Name,
                        'Default_Role__c' => resource.Roles__c,
                        'allocationsByProject' => new Map<String, Object>()
                    });
                }
            }

            // organize allocations by resource and project
            for (Team_Assignment__c allocation : allocations) {
                if (!resourceById.containsKey(allocation.IT_Resource__c)) {
                    resourceById.put(allocation.IT_Resource__c, new Map<String, Object> {
                        'Id' => allocation.IT_Resource__c,
                        'Name' => allocation.IT_Resource__r.Name,
                        'Default_Role__c' => allocation.IT_Resource__r.Roles__c,
                        'allocationsByProject' => new Map<String, Object>()
                    });
                }

                Map<String, Object> resource = (Map<String, Object>)resourceById.get(allocation.IT_Resource__c);
                Map<String, Object> allocationsByProject = (Map<String, Object>)resource.get('allocationsByProject');
                
                if (!allocationsByProject.containsKey(allocation.Life_Cycle__c)) {
                    allocationsByProject.put(allocation.Life_Cycle__c, new List<Object>());
                }

                projectById.put(allocation.Life_Cycle__c, new Map<String, Object> {
                    'Id' => allocation.Life_Cycle__c,
                    'Name' => allocation.Life_Cycle__r.Name
                });


                List<Object> projectAllocation = (List<Object>)allocationsByProject.get(allocation.Life_Cycle__c);

                Decimal left = Decimal.valueOf(startDate.daysBetween(allocation.Start_Date__c)) / slotSize;
                left = left.round(System.RoundingMode.FLOOR);
                
                Decimal right = Decimal.valueOf(startDate.daysBetween(allocation.End_Date__c)) / slotSize;
                right = right.round(System.RoundingMode.FLOOR);

                projectAllocation.add(new Map<String, Object> {
                    'Id' => allocation.Id,
                    'Start_Date__c' => allocation.Start_Date__c,
                    'End_Date__c' => allocation.End_Date__c,
                    'Status__c' => allocation.Status__c,
                    'Effort__c' => allocation.Effort__c,
                    'Number_of_Hours__c' => allocation.Number_of_Hours__c,
                    'projectName' => allocation.Life_Cycle__r.Name,
                    'color' => allocation.Life_Cycle__r.Color__c,
                    'left' => left,
                    'right' => right
                });

                roles.add(allocation.IT_Resource__r.Roles__c);
            }
        }

        data.put('projects', projectById.values());
        data.put('resources', resourceById.values());
        data.put('roles', roles);        
        return data;
    }

    @AuraEnabled
    public static List<Object> getResources() {
        List<Object> resources = new List<Object>();
        Id UserId = UserInfo.getUserId();
        for (IT_Resource__c r : [SELECT Id, Name, Roles__c
                              FROM IT_Resource__c
                              WHERE Active__c = True AND
                              (Owner.Id=:UserID OR Employee__c=:UserID)
                              ORDER BY Name]) {
            resources.add(new Map<String, Object> {
                'Id' => r.Id,
                'Name' => r.Name,
                'Default_Role__c' => r.Roles__c
            });
        }
        return resources;
    }

    @AuraEnabled
    public static List<IT_Portfolio_Management__c> getProjects() {
        return [SELECT Id, Name
                FROM IT_Portfolio_Management__c
                WHERE Active__c = true
                ORDER BY Name];
    }

    @AuraEnabled
    public static void saveAllocation(Id allocationId, Id projectId, Id resourceId, String effort, String status, String startDate, String endDate, Integer numberofHours) {
        Team_Assignment__c allocation = new Team_Assignment__c(
            Start_Date__c = DateTime.newInstance(Long.valueOf(startDate)).date(),
            End_Date__c = DateTime.newInstance(Long.valueOf(endDate)).date()
        );

        // update allocation
        if (null != allocationId) {
            allocation.Id = allocationId;
        } else {
            if (null != projectId) {
                allocation.Life_Cycle__c = projectId;
            }

            allocation.IT_Resource__c = resourceId;
        }

        if (String.isNotEmpty(effort)) {
            allocation.Effort__c = effort;
        }
            
        
        if (String.isNotEmpty(status)) {
            allocation.Status__c = status;

            // remove project
            if ('Unavailable' == status) {
                allocation.Life_Cycle__c = null;
            }
            allocation.Number_of_Hours__c = numberofHours;
            system.debug('Allocation Number of Hours |' + allocation.Number_of_Hours__c);
        }
        
        upsert allocation;
    }

    @AuraEnabled
    public static void deleteAllocation(Id allocationId) {
        delete new Team_Assignment__c(Id = allocationId);
    }
}