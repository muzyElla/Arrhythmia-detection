N=650000;
figure(1);
sqrs('106',N);
ann=rdann('106','qrs',[],N);
[tm,sig]=rdsamp('106',[],N);
plot(tm,sig(:,1),'y');hold on;grid on

% get P,T,R points 
ecgpuwave('106' , 'test1',1,5000,'qrs')
P=rdann('106','test1',[],[],[],'p');
T=rdann('106','test1',[],[],[],'t');
R=rdann('106','test1',[],[],[],'N');
R=R[(2:end)];
i=1;

plot(tm(P),sig(P),'go','MarkerFaceColour','g')
plot(tm(T),sig(T),'bo','MarkerFaceColour','b')
plot(tm(R),sig(R),'ko','MarkerFaceColour','k')

% get Q points
sqrs('106',[],N)
Q=rdann('106','qrs',[],N);
Q=Q[(2:end)];
plot(tm(Q),sig(Q,1),'ro','MarkerFaceColour','r')

% get S points
[pks,locs] = findpeaks(-sig(:,1));
i = 1;
j = 1;
while(i<length(R))
    while(j<length(locs))
        if(locs(j)>R(i))
            S(i) = locs(j);
            break;
        end
        j = j+1;
    end
    i = i+1;
end
plot(tm(S),sig(S,1),'mo','MarkerFaceColour','m')

% Calculate standard RRdeviation
i = 1;
while( i < length(R))
	span(i) = R(i+1)-R(i);
    RRspan(i) = tm(R(i+1))-tm(R(i));
    vRS(i) = sig(R(i),1)-sig(S(i),1);
    i = i+1;
end
average = sum(span)/length(span);
RavarageRRspan = sum(RRspan)/length(RRspan);
RRspanDifference = abs(RRspan-averageRRspan);        
RRdeviation = averageRRspan-0.28;

% anaomaly detection on R
i=1;
j=1;
while(i<length(RRspan))
	if (RRspan<RRdeviation)
		RRerrorStart = R(i);
	    RRerrorEnd  = R(i+1);
	else
		if (vRSspan<0.5)
			RSerrorStart = R(i);
		    RSerrorEnd = S(i);
		end
    end
    i = i+1;
end
% eliminate zero points
RRerrorStart(RRerrorStart==0) = [];
RRerrorEnd(RRerrorEnd==0) = [];
RSerrorStart(RSerrorStart==0) = [];
RSerrorEnd(RSerrorEnd==0) = [];
RRerror = RRerrorStart;
RRerror = RRerror.';

% Remove other points associated with R
i=1;
while(i<length(RRdeviation))
	P(P>RRerrorStart(i)-average & P<RRerrorStart(i)+average) = [];
	Q(Q>RRerrorStart(i)-average & Q<RRerrorStart(i)+average) = [];
	S(S>RRerrorStart(i)-average & S<RRerrorStart(i)+average) = [];
	T(T>RRerrorStart(i)-average & T<RRerrorStart(i)+average) = [];
	R(R>RRerrorStart(i)-average & R<RRerrorStart(i)+average) = [];

	i = i+1;
end

% Anomaly Detaection on P
i=1;
j=1;
while(i<=length(R))
	while(j<=length(P))
		if(P(j)>R(i)-0.6*avarage&&P(j)<R(i)+0.8*avarage)
			Pok(i) = P(j);
	    	RPok(i) = R(i);
	    	break
		end
		j = j+1;
	end

% Anomaly Detection on Q
	j = 1;
	while(j<=length(Q))
		if(Q(j)>R(i)-0.4*avarage&&Q(j)<R(i)+0.6*avarage)
			Qok(i) = Q(j);
	    	RQok(i) = R(i);
	    	break
		end
		j = j+1;
	end

% Anomaly Detaection on T 
	j = 1;
	while(j<=length(T))
		if(T(j)>R(i)-0.4*avarage&&T(j)<R(i)+0.6*avarage)
			Tok(i) = T(j);
	   	 	RTok(i) = R(i);
	    	break
		end
		j = j+1;
	end

% Anomaly Detaection on S  
	j = 1;
	while(j<=length(S))
		if(S(j)>R(i)-0.4*avarage&&S(j)<R(i)+0.6*avarage)
			Sok(i) = S(j);
	    	RSok(i) = R(i);
	    	break
		end
		j = j+1;
	end
	j=1;
	i=i+1;
end

% eliminate zero points
Pok(Pok==0)=[];
Qok(Qok==0)=[];
Sok(Sok==0)=[];
Tok(Tok==0)=[];
RPok(RPok==0)=[];
RQok(RQok==0)=[];
RSok(RSok==0)=[];
RTok(RTok==0)=[];
Perror = setdiff(P,Pok);
P = setdiff(P,Perror);
Qerror = setdiff(Q,Qok);
Q = setdiff(Q,Qerror);
Serror = setdiff(S,Sok);
S = setdiff(S,Serror);
Terror = setdiff(T,Tok);
T = setdiff(T,Terror);

RPerror = setdiff(R,RPok);
RQerror = setdiff(Q,RQok);
RSerror = setdiff(S,RSok);
RTerror = setdiff(T,RTok);

% Add 'x' on anomallies
plot(tm,sig(:,1),'y');hold on;grid on
plot(tm(P),sig(P),'go','MarkerFaceColour','g')
plot(tm(T),sig(T),'bo','MarkerFaceColour','b')
plot(tm(R),sig(R),'ko','MarkerFaceColour','k')
plot(tm(Q),sig(Q,1),'ro','MarkerFaceColour','r')
plot(tm(S),sig(S,1),'mo','MarkerFaceColour','m')

plot(tm(RRerrorStart),sig(RRerrorStart,1),'kx')
plot(tm(RRerrorEnd),sig(RRerrorEnd,1),'kx')
plot(tm(RSerrorStart),sig(RSerrorStart,1),'rx')
plot(tm(RSerrorEnd),sig(RSerrorEnd,1),'rx')
plot(tm(RPerror),sig(RPerror,1),'gx')
plot(tm(RQerror),sig(RQerror,1),'bx')
plot(tm(RSerror),sig(RSerror,1),'mx')
plot(tm(RTerror),sig(RTerror,1),'yx')

% classify annotations and remove repeat values
anomaly = [RRerror;RPerror;RQerror;RSerror;RTerror];
anomaly = sort(anomaly);
anomaly = unique(anomaly);
anomaly = find(ismember(number,anomaly)==1);

i = 1;
while(i<=length(numbers))
    mytype(i) = 'N';
    i = i+1;
end

i = 1;
while(i<=length(anomaly))
    mytype(anomaly(i)) = 'A';
    i = i+1;
end

