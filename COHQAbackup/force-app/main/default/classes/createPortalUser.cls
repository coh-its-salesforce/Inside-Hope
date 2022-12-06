global class createPortalUser{
    webservice static id getcreatedUser(User u){
        system.debug('user** '+u);
        insert u;
        return u.id;
    }
}