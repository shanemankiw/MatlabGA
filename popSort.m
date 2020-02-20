%按成本把样本排序
function popSorted = popSort(poptemp, price)
tmp = [price,poptemp];
tmp = sortrows (tmp, 1);
tmp(:,1) =[ ];
popSorted = tmp;