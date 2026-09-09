# CalcSeqSim function
function CalcSeqSim(seq1::String, seq2::String, matrix::Matrix)
    aas_unq = ["A", "C", "D", "E", "F", "G", "H", "I", "K", "L", "M", "N", "P", "Q", "R", "S", "T", "V", "W", "Y"]
    n = length(seq1)
    
    seq1 = string.(collect(seq1))
    seq2 = string.(collect(seq2))
    
    seq1_ix = [findfirst(==(x), aas_unq) for x in seq1]
    seq2_ix = [findfirst(==(x), aas_unq) for x in seq2]
    
    score = sum([matrix[x, y] for (x, y) in zip(seq1_ix, seq2_ix)])
    
    return score
end
