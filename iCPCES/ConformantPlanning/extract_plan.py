


def extract_ff_plan(output):
    plan = list()
    if 'ff: found legal plan as follows' in output:
        output = str(output).split('\n')
        found_plan_line = False
        for line in output:
            line = line.strip()
            if line.startswith('step'):
                found_plan_line = True
            if found_plan_line and line == '':
                break
            if found_plan_line and 'REACH-GOAL' not in line:
                line = line.split(':')
                action = line[1].strip()
                plan.append(action)
        return plan
    else:
        return None

def extract_fd_plan(output):
    plan = list()
    if 'Solution found!' in output:
        output = str(output).split('\n')
        # 寻找solution found的行数
        index = 0
        for line in output:
            line = line.strip()
            if 'Solution found!' in line:
                break
            index += 1
        # 读取plan
        for index in range(index+2, len(output)):
            line = output[index].strip()
            if 'Plan length' in line:
                break
            action = ' '.join(line.split()[:-1]).upper()
            plan.append(action)
        return plan
    else:
        return None