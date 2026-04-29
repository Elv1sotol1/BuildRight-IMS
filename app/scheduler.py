from apscheduler.schedulers.background import BackgroundScheduler
 
 
def start_scheduler(app):
    scheduler = BackgroundScheduler()
    def scheduled_backup():
        with app.app_context():
            from app.backup.utils import run_backup, delete_old_backups
            run_backup(backup_type='Scheduled', performed_by=None)
            delete_old_backups(keep=30)
    scheduler.add_job(scheduled_backup, 'cron', hour=2, minute=0)
    scheduler.start()
