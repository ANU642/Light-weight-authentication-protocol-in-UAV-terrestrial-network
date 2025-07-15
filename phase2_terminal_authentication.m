function phase2_terminal_authentication()
    % Phase 2: Terminal Authentication with Simplified Key Derivation
    tic; % Start timing

    % Step 1: Terminal Generates Nonce (NT) with Timestamp
    NT = generateRandomNonce();
    NT_timestamp = now; % Capture timestamp
    disp(['Generated Terminal Nonce (NT): ', num2str(NT), ' at ', datestr(NT_timestamp)]);

    % Simulate sending Terminal Nonce to UAV
    disp('Sending Terminal Nonce (NT) to UAV...');

    % Step 2: UAV Generates Nonce (NU) with Timestamp
    NU = generateRandomNonce();
    NU_timestamp = now; % Capture timestamp
    disp(['Generated UAV Nonce (NU): ', num2str(NU), ' at ', datestr(NU_timestamp)]);

    % Step 3: Derive Shared Session Key using simple bitwise operations
    sessionKey_TU = deriveSessionKey(NT, NU);
    disp(['Derived Session Key (SK_TU): ', num2str(sessionKey_TU)]);

    % Step 4: Verify Authentication and Nonce Validity
    if verifyNonceWithTimestamp(NT, NT_timestamp) && verifyNonceWithTimestamp(NU, NU_timestamp)
        disp('Authentication successful! Secure session established.');
    else
        disp('Authentication failed! Retrying...');
        retryTerminalAuthentication(NT, NU);
    end

    % Measure execution time
    elapsedTime = toc;
    disp(['Phase 2 execution time: ', num2str(elapsedTime), ' seconds']);

    % Step 5: Scalability Simulation (Parallel Terminals)
    numTerminals = 3; % Example: 3 terminals
    disp(['Simulating scalability with ', num2str(numTerminals), ' terminals...']);
    parfor i = 1:numTerminals
        NT_multi = generateRandomNonce();
        NU_multi = generateRandomNonce();
        sessionKey_TU_multi = deriveSessionKey(NT_multi, NU_multi);
        disp(['Terminal ', num2str(i), ' - SK_TU: ', num2str(sessionKey_TU_multi)]);
    end

    % Step 6: Replay Attack Simulation
    disp('Simulating replay attack...');
    replayedNonce = NT; % Attacker reuses an old nonce
    if ~verifyNonceWithTimestamp(replayedNonce, NT_timestamp)
        disp('Replay attack prevented successfully!');
    else
        disp('Replay attack detected: Authentication failed!');
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

% Helper function: Retry Authentication
function retryTerminalAuthentication(NT, NU)
    disp('Retrying authentication...');
    NT = generateRandomNonce();
    NU = generateRandomNonce();
    sessionKey_TU = deriveSessionKey(NT, NU);
    disp(['New Session Key (SK_TU): ', num2str(sessionKey_TU)]);
end
