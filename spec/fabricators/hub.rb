#encoding: utf-8
Fabricator(:hub, class_name: :hub) do
  category 1
  reflection "uma relfexão"
  diaries(count: 2)
  grade 8
  commentary "blablabla"
end