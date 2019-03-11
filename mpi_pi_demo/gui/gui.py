import subprocess
from kivy.app import App
from kivy.uix.widget import Widget

class GUIWidget(Widget):
    def button_handler(self):
        print("button pressed")
        num_points = self.ids["number_of_points_slider"].value
        print("number of points",str(int(num_points)))
        #launch a batch job
        output = subprocess.check_output(["sbatch", "../mpi_numpi.sh",(str(int(num_points)))])
        print(output)
        #should say "Submitted batch job <jobid>"
        jobid=int(output.split(" ")[3])
        self.ids["message_label"].text = "Submitted job "+str(jobid)

        #grab the job number, add to a list of queued/running jobs
        #spawn a seperate thread to monitor the queue
        #display output of last few completed jobs

    def update_queue(self):
        output = subprocess.check_output(["squeue","--format=\"%i %j %t %M %N %i\""])
        self.ids["queue_label"].text = output


class GUIApp(App):
    def build(self):
        return GUIWidget()

if __name__ == '__main__':
    GUIApp().run()
