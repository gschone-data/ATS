import yaml
import os
import yfinance as yf

dat = yf.Ticker("MSFT")

print(__file__)
print(os.path.join(os.path.dirname(__file__), '..'))
print(os.path.dirname(os.path.realpath(__file__)))
print(os.path.abspath(os.path.dirname(__file__)))

__location__ = os.path.realpath(
    os.path.join(os.getcwd(), os.path.dirname(__file__)))
print(__location__)

path = os.path.abspath(os.path.join(os.path.dirname(__file__),".."))
print(os.path.join(path, 'liste.yaml'))

f = open(os.path.join(path, 'liste.yaml'))
symbols = yaml.safe_load(f)['symbols']
with open(os.path.join(__location__, 'liste.yaml')) as stream:
    try:
        print(yaml.safe_load(stream))
    except yaml.YAMLError as exc:
        print(exc)