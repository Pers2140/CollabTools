
import mgraph_restapi as msgraph
from dotenv import load_dotenv
import os

load_dotenv()

my_spconn = msgraph.mgraph_rest_conn(os.environ['SERVICE_EMAIL'],os.environ['SERVICE_PASSWORD'],os.environ['CLIENT_ID'],os.environ['CLIENT_SECRET'],os.environ['SITE_ID'])

my_spconn.upload_user_file("b!GoMzd6NImEKkS7h8psO1Mal-S2J3q-1Jvy3dfVof4t2c7wenMrV6SoA4cZEqE54K","file_toupload.txt","text/plain")