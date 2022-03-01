#!/usr/bin/env python3
import re

	# TODO

FILENAME='csvs/Admin.profile-meta.csv'
OUTPUT_FILE='csvs/output.csv'

# load csv file
input_file = open(FILENAME, 'r')
Lines = input_file.readlines()

nodes = {}

count = 0
for line in Lines:
	count += 1
	line = line.strip()

	node = ''

	if "[" in line:
		# split on [
		node = line.split('[')[0]
	else:
		# split on first :
		node = line.split(':')[0]

	# print("Line{}: {} {}".format(count, node, line))

	# split into files - one per node
	if node not in nodes:
		nodes[node] = []

	nodes[node].append(line)

input_file.close()

# print ("Dict size: {}".format(len(nodes)))

keys = []

for key in nodes:
	# print(key)
	keys.append(key)

# sort lines inside each file
# sort keys
keys.sort()


output = open(OUTPUT_FILE, "w")
prior_item = ''
prior_node_1kv = ''
pattern = "\[(.*?)\]"


for node in keys:
	# TODO: sort nodes[key]

	for item in nodes[node]:

		# Check for duplicate line
		if prior_item == item:
			print ("skipping dupe: "+item)
			continue

		# check for duplicate "node.key:value" (with diff values)
		if "[" in item:
			
			# explode into key:values, get first key
			key_values = re.search(pattern, item).group(1)
			# print(key_values)

			if node != 'layoutAssignments':
				first_kv = key_values.split(',')[0]
				# print("1st key/v: " + first_kv)
			else:
				first_kv = key_values

			node_1kv = node + "." + first_kv
			# print("node_1kv: " + node_1kv)

			if prior_node_1kv == node_1kv:
				print ("Alert! dupe key collision:\n  "+item + "\n  "+prior_item)
				# continue


		# print(item)
		output.write(item)
		output.write("\n")
		prior_item = item
		prior_node_1kv = node_1kv


			# quit()







# print (type(nodes['userLicense']))
# print (type(nodes['classAccesses']))



output.close()







	# create output "sorted" csv file
	# for each node
	# load the node-file, in node alpha order

	# read node-file line by line

	# check for []s

		# if []
			# turn [] into dictionary
			# sort dict on key
			# output node
			# output key values in key alpha order

		# if no []
			# output node and value



