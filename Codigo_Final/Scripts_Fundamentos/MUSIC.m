delta=0;
 
for count=1:1:run_times
% Generating source samples
s1 = randn(1,Nsam);
S1 = [s1];
s2 = randn(1,Nsam);
S2 = [s2];
% Generating noise
snr=20;
noise_variance = 10^(-snr/10);
noise = sqrt(noise_variance/2) * (randn(L,Nsam)+j*randn(L,Nsam));
 
% Received signal
x = A1 * S1 +A2 * S2 + noise;
 
% Calculating The covariance matrix of the received signal
N=size(x,2);
Rx=zeros(L,L);
for k1=1:L
    for k2=1:L
        Rx(k1,k2)=(1/N)*sum(x(k1,:).*conj(x(k2,:)));
    end
end
 
% Eigenvalue decomposition and sorting
[E,Lambda]=eig(Rx);
lam_vec = zeros(1,L);
 
for k = 1:L;
    lam_vec(k) = real(Lambda(k,k));
end
[lam_vec,Ind]=sort(lam_vec,'descend');
Lambda_I = diag(lam_vec);
 
E_I=zeros(L,L);
for k=1:L
    E_I(:,k) = E(:,Ind(k));
end
 
% Costructing the noise subspace
En=[];
for q=Ns+1:L
    En=[En,E_I(:,q)];
end
 
% computing MUSIC spectrum
stp=0.001;
P_MU=zeros(1,6284);
cnt=0;
for w = 2*pi*spacing*sin(-pi/2): stp: 2*pi*spacing*sin(pi/2)
    cnt=cnt+1;
    v = exp(-j* w * [0:L-1]');
    theta(cnt)=180*asin(w/2/pi/spacing)/pi;
    P_MU(cnt)=(v'*v)/(v'*En*En'*v);
end
[PMAX,ind]=max(P_MU);
theta=theta(ind-1);
 
delta=delta+(theta-dire1)^2;
end
MMSE=delta/run_times
 
% plotting MUSIC spectrum
w = 2*pi*spacing*sin(-pi/2):stp: 2*pi*spacing*sin(pi/2);
x_theta=180*asin(w/2/pi/spacing)/pi;
figure,plot(x_theta,10*log10(abs(P_MU)))
grid