%���ɱ�����������
function popSorted = popSort(poptemp, price)
tmp = [price,poptemp];
tmp = sortrows (tmp, 1);
tmp(:,1) =[ ];
popSorted = tmp;