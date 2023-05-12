from datetime import datetime, timedelta, timezone
from aws_xray_sdk.core import xray_recorder

from lib.db import db

class UserActivities:
  def run(user_handle):
    #segment = xray_recorder.begin_segment('user_activities') ---Not really needed
    model = {
        'errors': None,
        'data': None
      }
    print('User_handle', user_handle)
    if user_handle == None or len(user_handle) < 1:
      model['errors'] = ['blank_user_handle']
    else:
      sql = db.template('users','show')
      print('SQL==', sql)
      results = db.query_object_json(sql, {'handle': user_handle}) 
      print('Results',results)
      now = datetime.now()
      model['data'] = results

    #subsegment = xray_recorder.begin_subsegment('mock-data')
    # Xray  ---
    #dict ={
    #  "now": now.isoformat(),
    #  "results-size": len(model['data'])
    #}  
 
    #subsegment.put_metadata('key', dict, 'namespace')
    #xray_recorder.end_subsegment()
    return model    