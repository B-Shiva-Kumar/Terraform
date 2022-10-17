# sample program for aws lamda

def lamda_handler(event, context):
    message = "Hello {} !".format(event[0])
    return{
        'message': message
    }