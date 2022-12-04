global class immicreatePortalUser{
    webservice static id getcreatedUser(User u){
        system.debug('user** '+u);
       try
       { insert u;
       }
       Catch(exception e)
       {
       }
        return u.id;
    }
}