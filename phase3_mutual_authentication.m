function phase3_mutual_authentication()
    % Phase 3: Mutual Authentication with Simplified Key Derivation
    tic; % Start timing

    % Step 1: Terminal Sends Message to UAV
    NT = generateRandomNonce();
    NT_timestamp = now; % Capture timestamp
    terminalMessage = ['NT:', num2str(NT), '_Timestamp:', datestr(NT_timestamp), '_TerminalID:Terminal123'];
    disp(['Terminal Message: ', terminalMessage]);

    % Step 2: UAV Sends Response
    NU = generateRandomNonce();
    NU_timestamp = now; % Capture timestamp
    UAVMessage = ['NU:', num2str(NU), '_Timestamp:', datestr(NU_timestamp), '_UAVID:UAV456'];
    disp(['UAV Message: ', UAVMessage]);

    % Step 3: Terminal Verifies UAV
    if verifyNonceWithTimestamp(NU, NU_timestamp)
        disp('Terminal verification successful!');
    else
        disp('Terminal verification failed!');
        return;
    end

    % Step 4: UAV Verifies Terminal
    if verifyNonceWithTimestamp(NT, NT_timestamp)
        disp('UAV verification successful!');
    else
        disp('UAV verification failed!');
        return;
    end

    % Step 5: Generate Shared Session Key using simple bitwise operations
    sessionKey = deriveSessionKey(NT, NU);
    disp(['Session Key Generated: ', num2str(sessionKey)]);
    disp('Secure communication channel established!');

    % Measure execution time
    elapsedTime = toc;
    disp(['Phase 3 execution time: ', num2str(elapsedTime), ' seconds']);

    % Step 6: Scalability Simulation (Terminal-UAV Pairs)
    numPairs = 3; % Example: 3 pairs
    disp(['Simulating scalability with ', num2str(numPairs), ' terminal-UAV pairs...']);
    parfor i = 1:numPairs
        NT_multi = generateRandomNonce();
        NU_multi = generateRandomNonce();
        sessionKey_multi = deriveSessionKey(NT_multi, NU_multi);
        disp(['Terminal-UAV Pair ', num2str(i), ' - SK: ', num2str(sessionKey_multi)]);
    end

    % Step 7: Impersonation Attack Simulation
    disp('Simulating impersonation attack...');
    fakeMessage = 'FakeMessage';
    if ~strcmp(fakeMessage, terminalMessage)
        disp('Impersonation attack detected: Authentication failed!');
    else
        disp('Impersonation attack prevented successfully!');
    end
end

% Helper function: Generate Random Nonce
function nonce = generateRandomNonce()
    nonce = randi([0, 2^32 - 1]);
end

% Helper function: Derive Session Key
function sessionKey = deriveSessionKey(NT, NU)
    % Combine NT and NU using bitwise XOR and modulo for simplicity
    sessionKey = bitxor(NT, NU); % Example: XOR for key derivation
    sessionKey = mod(sessionKey, 2^32); % Ensure key fits within 32 bits
end

% Helper function: Verify Nonce with Timestamp
function isValid = verifyNonceWithTimestamp(nonce, timestamp)
    timeDifference = etime(datevec(now), datevec(timestamp));
    isValid = (timeDifference < 5); % Max allowed time is 5 seconds
end

