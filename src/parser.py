from collections import namedtuple

Usage = namedtuple('Usage', 'report headers total storage data')

def parse_usage_output(fpath):
    with open(fpath) as f:
        report = next(f)
        report += next(f)
        headers = [filter(None, next(f).strip().split('  ')[1:])]
        headers.append(filter(None, (next(f).strip().split('  '))))
        headers = [f'{header_1.strip()} {header_2.strip()}' for header_1, header_2 in  zip(*headers)]
        _ = next(f)
        data = {}
        for row in f:
            if row.startswith('---'):
                break
            line = row.split()
            data[line[0]] = {k:float(v) for k, v in zip(headers, line[1:])}
        total = next(f).split()
        storage = f.read().strip()
    return Usage(report, headers, total, storage, data)   