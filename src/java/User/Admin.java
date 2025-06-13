package User;

public class Admin {
    
    private String userID;
    private String adminID;
    private String name;
    private String email;
    private String phoneNumber;
    private String profileImagePath;

    public Admin() {
    }

    public Admin(String userID, String adminID, String name, String email, String phoneNumber, String profileImagePath) {
        this.userID = userID;
        this.adminID = adminID;
        this.name = name;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.profileImagePath = profileImagePath;
    }

    public String getUserID() {
        return this.userID;
    }

    public void setUserID(String userID) {
        this.userID = userID;
    }

    public String getAdminID() {
        return this.adminID;
    }

    public void setAdminID(String adminID) {
        this.adminID = adminID;
    }

    public String getName() {
        return this.name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return this.email;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }
    

    public void setEmail(String email) {
        this.email = email;
    }

    public String getProfileImagePath() {
        return this.profileImagePath;
    }

    public void setProfileImagePath(String profileImagePath) {
        this.profileImagePath = profileImagePath;
    }

    @Override
    public String toString() {
        return "Admin{" + "userID=" + userID + ", adminID=" + adminID + ", name=" + name + ", email=" + email + ", profileImagePath=" + profileImagePath + '}';
    }


}
