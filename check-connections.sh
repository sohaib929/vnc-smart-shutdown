import json
import boto3

def lambda_handler(event, context):
    
    region = event['queryStringParameters']['region']
    instance_tag_value = event['queryStringParameters']['smartStartTag']
    instance_ids = []
    instance_ids_reboot = []
    
    ec2 = boto3.client('ec2', region_name=region)

    filter = [{
        'Name': 'tag:SmartStart', 
        'Values': [instance_tag_value]
    }]
    
    instances = ec2.describe_instances(Filters=filter)
    for resevation in instances['Reservations']:
        for reservation_instance in resevation['Instances']:
            if reservation_instance['State']['Code'] == 80:
                instance_ids.append(str(reservation_instance['InstanceId']))
                
            if reservation_instance['State']['Code'] == 16:
                instance_ids_reboot.append(str(reservation_instance['InstanceId']))
    
    if len(instance_ids) > 0:
        ec2.start_instances(InstanceIds=instance_ids)
    
    if len(instance_ids_reboot) > 0:    
        ec2.reboot_instances(InstanceIds=instance_ids_reboot)
        
    return {
        'statusCode': 200,
        'body': json.dumps('Started instance(s) {} and rebooted instance(s) {}'.format(instance_ids, instance_ids_reboot))
    }
