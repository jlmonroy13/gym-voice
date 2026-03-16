import React from 'react';
import {render, screen} from '@testing-library/react-native';
import App from '../../App';

describe('App', () => {
  it('renders the root screen copy', () => {
    render(<App />);

    expect(screen.getByText('GymVoice')).toBeTruthy();
    expect(
      screen.getByText('Registrador de entrenamientos por voz (MVP scaffold).'),
    ).toBeTruthy();
  });
});

