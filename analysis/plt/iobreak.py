

command_id = 1036
qid_m = (command_id >> 10)
command_id &= 0x3ff

print("qid_m:", qid_m)
print("command_id_n:", command_id)