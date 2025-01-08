package cowork;

import java.time.LocalDateTime;

public class Notification {

    private int idNotification;
    private int idUser;
    private String notificationDate;
    private String message;
    private boolean isRead;

    // Constructeur
    public Notification(int idNotification, int idUser, String notificationDate, String message, boolean isRead) {
        this.idNotification = idNotification;
        this.idUser = idUser;
        this.notificationDate = notificationDate;
        this.message = message;
        this.isRead = isRead;
    }

    // Getters et Setters
    public int getIdNotification() {
        return idNotification;
    }

    public void setIdNotification(int idNotification) {
        this.idNotification = idNotification;
    }

    public int getIdUser() {
        return idUser;
    }

    public void setIdUser(int idUser) {
        this.idUser = idUser;
    }

    public String getNotificationDate() {
        return notificationDate;
    }

    public void setNotificationDate(String notificationDate) {
        this.notificationDate = notificationDate;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public boolean isRead() {
        return isRead;
    }

    public void setRead(boolean isRead) {
        this.isRead = isRead;
    }
}
